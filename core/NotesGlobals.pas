//
//    NotesGlobals - vari�veis, constantes, etc. globais do Notes
//
//    Notes, https://github.com/jonasraoni/notes
//    Copyright (C) 2003-2004, Equipe do Notes.
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//


(*
  @abstract(NotesGlobals - vari�veis, constantes, etc. globais do Notes.)
  @author(Jonas Raoni Soares da Silva <jonasraoni@gmail.com>)
  Esta Unit possu� vari�veis (para caminhos e outro trecos), constantes
  (principalmente de nome de arquivos), objetos (NProfile, NotesCmdLine)
  e outras coisas que devem ser usadas em todo o programa.
*)
unit NotesGlobals;

interface

uses
  Classes, NotesEditorTab, NotesConfig, NotesMRU, NotesProfile, XPMenu,
  NotesCmdParser, Controls, NotesEditorTabPosList, NotesActions,
  NotesTabsmanager;

type

  // tipo usado para que @code(ActiveEditorTab) possa ser global
  TNotesActiveEditorTabFunc = function : TNotesEditorTab of object;
  // tipo usado para que @code(GoToEditTabPos) possa ser global
  TNotesGoToEditTabPosFunc  = function (const etpos: TNotesEditorTabPos; AsError: boolean): boolean of object;
  // tipo usado para que as a��es do Notes possam ser executados de outros
  // lugares al�m do form principal sem tornar a TActionList vis�vel
  TNotesExec = procedure (const ActionName: string) of object;
  // tipo usado para que as a��es dos pain�is possam ser executadas de qualquer
  // lugar sem tornar o gerenciador de pain�is vis�vel
  TNotesPanelExec = function (const PanelName, PanelAction, Params: string): string of object;
  // tipo usado para permitir setar propriedades dos pain�iss
  TNotesPanelSetProperty = procedure (const PanelName, PanelProperty, Value: string) of object;
  // tipo usado para permitir ler propriedades dos pain�iss
  TNotesPanelGetProperty = function (const PanelName, PanelProperty: string): string of object;
  // tipo usado para que forms e pain�is possam mostrar mensagens na status bar
  TNotesSetStatusMessage = procedure (const msg: string) of object;

type
  // Tipo de drag and drops suportados pelo editor
  // @code(dtNcl) - Item da Notes Code Library
  // @code(dtFileToInsert) - Arquivo cujo conte�do deve ser insrido no txt
  // @code(dtFile) - Arquivo que deve ser aberto
  // @code(dtTextToInsert) - Texto que deve ser inserido
  TNotesDragType = (dtNcl, dtFileToInsert, dtFileToOpen, dtTextToInsert);

  // Objeto usado para fazer Drag and Drop para o editor
  // e do editor para outros lugares. Para fazer Drag and
  // Drop no Notes, crie uma inst�ncia de @code(TNotesDragObject)
  // no evento OnStartDrag do objeto a ser arrastado.
  // Lembre-se de limpar o objeto em OnEndDrag.
  // @code(DragType) indica que tipo de a��o o editor deve tomar
  // e que tipo de dado est� contido em @code(Data). Vide
  // @link(TNotesDragType) para mais informa��es.
  TNotesDragObject = class(TDragObject)
  public
    DragType: TNotesDragType;
    Data: string;
  end;

const
  NOTES_NICKNAME = 'Notes 2004';
  NOTES_VERSION = '1.9';

  NOTES_FILETYPE_CONFIG_EXTENSION = '.xml';
  NOTES_FILETYPE_HIGHLIGHTER_EXTENSION = '.nhl';
  NOTES_FILETYPE_HIGHLIGHTERSTYLES_EXTENSION = '.nhs';
  NOTES_CODELIBRARY_EXTENSION = '.ncl';
  NOTES_DESCRIPTION_EXT= '.help';
  NOTES_RUN_EXTENSION = '.xml';
  NOTES_TEMPLATE_EXT= '.ntpl';
  NOTES_LOCALEFILE_EXT = '.nls';
  NOTES_EDITOR_STATE_EXT = '.nes';
  NOTES_SMART_INDENT_EXT = '.nsi';
  NOTES_MACRO_EXT= '.js';

  NOTES_ASSOCIATIONS_FILENAME = 'extlang.dat';
  NOTES_FAVORITES_FILENAME = 'fav.dat';
  NOTES_MRU_FILENAME = 'mru.dat';
  NOTES_SEARCHHIST_FILENAME = 'find.dat';
  NOTES_GREPDIRHIST_FILENAME = 'grepdir.dat';
  NOTES_GREPEXTHIST_FILENAME = 'grepext.dat';
  NOTES_DIR2HIST_FILENAME = 'file2.dat';
  NOTES_DIRHIST_FILENAME = 'file.dat';
  NOTES_CONFIG_FILENAME = 'nconfig.xml';
  NOTES_OPTIONS_FILENAME = 'nopts.xml';
  NOTES_PANELS_OPTIONS_FILENAME = 'npanels.xml';
  NOTES_FILETYPE_EXTENSION_FILENAME = 'ext.dat';
  NOTES_KEYMAP_FILENAME = 'keymap.nkm';
  NOTES_ACTIVE_PROFILE_FILENAME = 'ActiveProfileV3.dat';
  NOTES_DLGFILTERS_FILENAME= 'dlgfilters.dat';
  NOTES_FOLDER_MENUS_KEYMAP_FILENAME= 'nfmkm.dat';

  NOTES_ASCII_DIRNAME = 'ascii';
  NOTES_FILETYPES_DIRNAME = 'filetypes';
  NOTES_CODELIBRARY_DIRNAME = 'library';
  NOTES_TEMPLATELIBRARY_DIRNAME = 'templates';
  NOTES_RUN_DIRNAME = 'run';
  NOTES_PROFILES_DIRNAME = 'profiles';
  NOTES_KEYMAPS_DIRNAME = 'keymaps';
  NOTES_DATA_DIRNAME = 'Notes2004';
  NOTES_LOCALE_DIRNAME = 'locale';
  NOTES_EDITOR_STATE_DIRNAME= 'editorstate';
  NOTES_MACROS_DIRNAME= 'macros';

const
  // Opcoes de busca
  NOTES_SEARCH_WHOLEWORDS    = $00000001;
  NOTES_SEARCH_WILDCARDS     = $00000002;
  NOTES_SEARCH_CASESENSITIVE = $00000004;
  NOTES_SEARCH_REGEXP        = $00000008;
  NOTES_SEARCH_SUBDIRS       = $00000016;

var
  // op��es de busca
  NotesSearchOptions: integer;
  //extens�es para di�logo abrir/salvar
  NFilterExt: string;
  //evita que mensagens apare�am na statusbar enqunato se est� mostrando algo nela...
  NShowinProgress: boolean;
  //evita novas inst�ncias de frmSearchAndReplcae  (VAI SER MODIFICADO, N�O USE!)
  NSearchShowin: boolean;
  //guarda o texto para a fer desfazer ferramentas
  NUndoTool:string;
  //aramazena o pr�ximo na cadeia de cliboard viwers...
  NNextInClipboardChain: THandle;
  //Armazena informa��es sobre o profile atual.
  NProfile: TNotesProfile;
  //Caminho para o execut�vel
  NExeFile: string;
  //Pasta do execut�vel
  NExePath: string;
  //Pasta de dados do Notes
  NDataPath: string;
  //Pasta contendo profiles
  NProfilesPath : string;
  // Guarda a �ltima linha de comando
  NotesCmdLine: TNotesCmdParser;
  // Retorna o TNotesEditorTab ativo
  ActiveEditorTab: TNotesActiveEditorTabFunc;
  // Vai para a posi��o e arquivo descritos em @code(etpos)
  GoToEditorTabPos: TNotesGoToEditTabPosFunc;
  // Imagelist contendo os �cones usados no Notes
  NImages: TImageList;
  // Gerenciador de a��es do Notes. Use para criar/destruir a��es/menus
  // dinamicamente e para controlar o estado habilitado/desabilitado
  // de a��es
  ActionMan: TNotesActionManager;

  // executa uma a��o do Notes
  NotesExec: TNotesExec;
  // executa uma a��o de um painel
  PanelExec: TNotesPanelExec;
  // seta uma propriedade de um painel
  PanelSetProperty: TNotesPanelSetProperty;
  // pega uma propriedade de um painel
  PanelGetProperty: TNotesPanelGetProperty;

  // gerenciado de tabs
  tabs: TNotesTabsManager;

  // seta a mensagem que aparece na statusbar
  setStatusMsg: TNotesSetStatusMessage;

  // Faz as teclas de atalho pararem de funcionar.
  // Necess�rio no di�logo de automcpletar
  stopNotesShortcuts: TNotifyEvent;
  restoreNotesShortcuts: TNotifyEvent;

implementation

initialization begin
  NProfile := TNotesProfile.Create;
  NotesCmdLine:= TNotesCmdParser.Create;
end;

finalization begin
  NProfile.Free;
  NotesCmdLine.Free;
end;


end.
