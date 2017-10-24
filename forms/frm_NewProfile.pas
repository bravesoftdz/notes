unit frm_NewProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, CheckLst;

type
  TfrmNewProfile = class(TForm)
    pgWiz: TPageControl;
    btCancel: TButton;
    btForward: TButton;
    tsFileTypesConfig: TTabSheet;
    tsFiletypesInstall: TTabSheet;
    chlbFiletypes: TCheckListBox;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    pbFiletypes: TProgressBar;
    laFiletypes: TLabel;
    tsStart: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Bevel3: TBevel;
    tsEmulationConfig: TTabSheet;
    tsEmulationInstall: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    Bevel4: TBevel;
    Label9: TLabel;
    Label10: TLabel;
    laEmulations: TLabel;
    ProgressBar1: TProgressBar;
    Bevel5: TBevel;
    lbEmulations: TListBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    btSelAll: TButton;
    btSelNone: TButton;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    procedure btCancelClick(Sender: TObject);
    procedure btForwardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btSelAllClick(Sender: TObject);
    procedure btSelNoneClick(Sender: TObject);
  private
    fName: string;
    // diret�rio do Novo profile
    fProfileDir: string;
    // diret�rio de onde os dados s�o copiados
    fDataDir: string;
  public
    // Nome do profile a ser criado
    property NewProfileName: string read fName  write fName;
  end;

var
  frmNewProfile: TfrmNewProfile;

implementation

{$R *.dfm}

uses NotesCopyDeldialog, NotesProfile, NotesGlobals, NotesUtils;

procedure TfrmNewProfile.btCancelClick(Sender: TObject);
begin
  if msgYesNo('Voc� tem certeza que quer cancelar?!', handle) = IdNo then Exit;

  if pgWiz.ActivePage <> tsStart then
  begin
    // Vamos ter que limpar o que j� foi instalado
    Hide;
    with TfrmCopyDel.Create(nil) do
    begin
      try
        operation:= foDel;
        DisableCancelButton:= true;
        Path:= fProfileDir;
        Mask:='*';
        Description:= 'O Notes est� limpando os arquivos que j� haviam sido criados. Por favor, aguarde.';
        theCaption:= 'Cancelando...';
        FilePrefix:= 'Deletando';
        if Execute then
          RemoveDir(fProfileDir);
      finally
        Free;
      end;
    end;
  end;
  modalResult:= mrCancel;
end;


procedure TfrmNewProfile.btForwardClick(Sender: TObject);
var
  Tree: PNotesFolderTree;
  ft: PNotesFolderTree;
  I: integer;
begin

  if pgWiz.ActivePage = tsStart then
  begin
    // instalamos os arquivos b�sicos
    CreateDir(fProfileDir);
    screen.Cursor:= crHourGlass;
    try
      BuildFolderTree(Tree, fDataDir + 'config\', ftAll, True);
      CopyfolderTree(Tree, fDataDir + 'config\', fProfileDir, false, nil);
      pgWiz.ActivePage:= tsFileTypesConfig;
      // pegamos os tipos de arquivo do diret�rio de dados
      BuildFolderTree(ft, fDataDir + 'filetypes\', ftOnlyFolders);
      // listamos os tipos de arquivos no checklistbox
      for I:=0 to High(ft^) do
        chlbFileTypes.Items.Add(ft^[I].Path);
      // checamos todos os items
      for I:=0 to chlbFileTypes.Count - 1 do
        chlbFileTypes.Checked[I]:= true;
    finally
      FreeFolderTree(Tree);
      FreeFolderTree(ft);
      screen.Cursor:= crDefault;
    end;
  end else
  if pgWiz.ActivePage = tsFileTypesConfig then
  begin
    // preparamos a pr�xima p�gina
    pbFiletypes.Min:= 0;
    pbFileTypes.Step:= 1;
    pbfiletypes.Max:= 0;

    // O tipo de arquivo "texto" SEMPRE � instalado
    I:= chlbFileTypes.Items.IndexOf('texto');
    if I > -1 then
      chlbFileTypes.Checked[I]:= true;

    // ajustamos a proprieade max para o n�mero de items checados
    for I:=0 to chlbFileTypes.Count - 1 do
      if chlbFileTypes.Checked[I] then
        pbfiletypes.Max:= pbfiletypes.Max + 1;

    // teremos 4 passos para cada filetype
    // para que o programa pare�a mais responsivo
    pbFileTypes.Max:= pbFileTypes.Max * 4;

    pgWiz.ActivePage:= tsFileTypesInstall;
    btCancel.Enabled:= false;
    btForward.Enabled:= false;

    // instalamos cada um dos items checados
    for I:=0 to chlbFileTypes.Count - 1 do
    begin
      if chlbFileTypes.Checked[I] then
      begin
        laFileTypes.Caption:= 'Instalando suporte a ' + chlbFileTypes.Items.Strings[I] + '...';
        Application.ProcessMessages;
        // criamos a pasta onde ficara o tipo
        ForceDirectories(fProfileDir+ 'filetypes\' + chlbFileTypes.Items.Strings[I]);
        BuildfolderTree(Tree, fDataDir+ 'filetypes\' + chlbFileTypes.Items.Strings[I] + '\',
          ftAll, True);
        try
          pbFileTypes.StepIt;
          CopyfolderTree(Tree, fDataDir+ 'filetypes\' + chlbFileTypes.Items.Strings[I] + '\', fProfileDir+ 'filetypes\' + chlbFileTypes.Items.Strings[I] + '\', false, nil);
          pbFileTypes.StepIt;
        finally
          pbFileTypes.StepIt;
          FreeFolderTree(Tree);
          pbFileTypes.StepIt;
        end;
      end;
    end;

    modalResult:= mrOk;
  end;

  // TODO >> ADICIONAR SUPORTE A INSTALA��O DE EMULA��ES!

end;

procedure TfrmNewProfile.FormShow(Sender: TObject);
begin
  fDataDir:= addSlash(NExePath) + 'data\';
  fProfileDir:= AddSlash(NProfilesPath + fName);
end;

procedure TfrmNewProfile.btSelAllClick(Sender: TObject);
Var
  I: integer;
begin
  for I:=0 to chlbFileTypes.Count - 1 do
    chlbFileTypes.Checked[I]:= true;
end;

procedure TfrmNewProfile.btSelNoneClick(Sender: TObject);
Var
  I: integer;
begin
  for I:=0 to chlbFileTypes.Count - 1 do
    chlbFileTypes.Checked[I]:= false;
end;


end.
