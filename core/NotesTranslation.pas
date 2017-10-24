//
//    NotesTranslation - classe para internacionaliza��o do Notes
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
  @abstract(NotesTranslation - classe para internacionaliza��o do Notes.)
  @author(Anderson R. Barbieri <notesnr@ig.com.br>)
*)
unit NotesTranslation;

interface

uses Windows, Classes, sysUtils, strUtils, typInfo, Controls;

type
  // Classe que deve ser usada para internacionalizar o Notes
  TNotesTranslation = class(TObject)
  private
    fFile: string;
    fCache: string;
    procedure setFile(const Value: string);
  public
    // Traduz a inst�ncia do componente passado em obj
    procedure TranslateComponent(const obj: TComponent);
    // Pega uma mensagem traduzida. Passe o nome da mensagem em
    // MsgName. Se a mensagem n�o for encontrada, MsgDefault ser� retornado
    // Um cache do arquivo de tradu��o � criado da primeira vez que voc�
    // chama a fun��o e pode ser liberado atrav�s de releaseCache
    function  getMsgTranslation(const MsgName, MsgDefault: string): string;
    // Libera o cache atual (use se voc� n�o quiser destruir o objeto)
    procedure releaseCache;
    // Arquivo com as strings localizadas
    property TranslationFile: string read fFile write setFile;
  end;

implementation

uses NotesSeeker, NotesUtils;

{
  Usei rotinas ao inv�s de m�todos para as rotinas que
  ser�o mais chamadas. Isso deve dar um bom boost na
  performance por que rotinas com at� 3 par�metros
  (como � o caso das abaixo) s�o chamadas usando a mem�ria
  do pr�prio processador o que � absurdamente mais r�pido :)
}

// Seta a propriedade passada para um componente
// S� permite setar Caption, Text e Hint, por raz�es de seguran�a
// (veja XGUtils.pas para uma rotina que pode setar todo tipo de propriedades)
procedure setProperty(obj: TComponent; propName, propValue: string);
var
  propInfo : PPropInfo;
  S: string;
begin
  S:= AnsiLowerCase(propName);
  if (S <> 'caption') and (S <> 'text') and (S <> 'hint') then
    Exit;

  propInfo := getPropInfo(obj, propName);

  if propInfo = nil then
    Exit;

  if propInfo.PropType^.Kind in [tkString, tkLString, tkWString] then
    setStrProp(obj, propInfo, propValue);
end;

// Tenta pegar o valor de uma propriedade de um objeto
// se n�o conseguir, retorna false. O valor � retornado
// no par�metro Value. Como a setProperty, s� funciona
// para propriedades do tipo string
function getPropValue(Obj: TComponent; PropName: string; var Value: string): boolean;
var
  propInfo : PPropInfo;
begin
  Result:= false;
  if (obj <> nil) and (PropName <> '') then
  begin
    propInfo := getPropInfo(obj, Trim(PropName));

    if propInfo = nil then
      Exit;

    if propInfo.PropType^.Kind in [tkString, tkLString, tkWString] then
    begin
      Value:= getStrProp(obj, propInfo);
      Result:= true;
    end;
  end;
end;

// As strings traduzidas devem usar \n para quebra de linha
// e \t para tab. Para imprimir "\n" deve-se usar "\\n" e
// assim por diante. Essa fun��o converte uma string traduzida
// para uma string normal
function DecodeTranslatedStr(const S: string): string;
begin
  // por via das d�vidas limpamos a string antes
  Result:= StringReplace(Result,''#13,'', [rfReplaceAll]);
  Result:= StringReplace(Result,''#10,'', [rfReplaceAll]);

  Result:= StringReplace(S,'\\',''#7, [rfReplaceAll]);
  Result:= StringReplace(Result,'\n',''#13#10, [rfReplaceAll]);
  Result:= StringReplace(Result,'\t',''#9, [rfReplaceAll]);
  Result:= StringReplace(Result,''#7,'\', [rfReplaceAll]);
end;

// Codifica a string para que ela possa ser traduzida
function EncodeStrToTranslation(const S: string): string;
begin
  Result:= StringReplace(S,'\',''#7, [rfReplaceAll]);
  Result:= StringReplace(Result,''#13#10,'\n', [rfReplaceAll]);
  Result:= StringReplace(Result,''#13,'\n', [rfReplaceAll]);
  Result:= StringReplace(Result,''#10,'\n', [rfReplaceAll]);
  Result:= StringReplace(Result,''#9,'\t', [rfReplaceAll]);
  Result:= StringReplace(Result,''#7,'\\', [rfReplaceAll]);
end;


{ TNotesTranslation }

function TNotesTranslation.getMsgTranslation(const MsgName,
  MsgDefault: string): string;
Var
  C: Cardinal;
  EndPos, StartPos: integer;
  S: string;
begin
  Result:= MsgDefault;
  if MsgName = '' then Exit;

  with TNotesSeeker.Create do
  begin
    try
      EnableOptions(False, False, False, False, False);
      SearchStr:= MsgName;
      // Se o cache estiver vazio, carregamos o arquivo
      KeepText:= false;
      if (fCache = '') then
        if (FileExists(FFile)) then
          fCache:= FileToStr(fFile)
        else
          Exit;
      Text:= fCache;
      StartSearch;
      while Search do
      begin
        C:= High(Integer);
        if CurByte < C then
        begin
          StartPos:= findLineBreak(fCache, CurByte, true);
          EndPos:= findLineBreak(fCache, CurByte, false);
          // na hora de copiar tiramos os caracteres #13
          S:= Copy(fCache, StartPos+1, EndPos - StartPos -1);
          if S <> '' then
          begin
            // Provavelmente achamos o que quer�amos. Mas ainda temos
            // que verificar se a linha come�a com "$NomeDaMensagem="
            EndPos:= Pos('=', S);
            // armazenamos o resultado (lembrar de limpar se a verifica��o falhar)
            Result:= DecodeTranslatedStr(Copy(S, EndPos+1, length(S)));
            if SameText(StringReplace(Copy(S, 1, EndPos), ' ', '', [rfReplaceAll]), '$' + MsgName +'=') then
              Break
            else
              Result:= MsgDefault;
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TNotesTranslation.releaseCache;
begin
  fCache:= '';
end;

procedure TNotesTranslation.setFile(const Value: string);
begin
  fFile := Value;
  fCache:='';
end;

procedure TNotesTranslation.TranslateComponent(const obj: TComponent);
Var
  objChild: TComponent;
  LastChild: TComponent;
  LineLen, I: integer;
  TxtFile : TextFile;
  S, S2, oName, oProp, oValue: string;
begin
  LastChild := nil;
  if FileExists(fFile) then
  begin
    AssignFile( TxtFile, fFile );
    Reset( TxtFile );
    while not EOF( TxtFile ) do
    begin
      ReadLn( TxtFile, S );
      LineLen := Length( S );
      if LineLen > 0 then
      begin
        // Temos que checar se a linha n�o come�a com # (coment�rio) ou $ (mensagem)
        S2:= Trim(S);
        if (S2 <> '') and (S2[1] <> '#') and (S2[1] <> '$') then
        begin
          I:= Pos('=', S);
          S2:= Trim(Copy(S, 1, I-1));
          oValue:= Copy(S, I+1, LineLen);
          I:= Pos('.', S2);
          oName:= Copy(S2, 1, I-1);
          oProp:= Copy(S2, I+1, LineLen);
          // Como � normal que tenhamos o objeto repetido duas ou mais
          // vezes um ap�s o outro, guardamos o��ltimo componente e vemos
          // se n�o � ele que temos q encontrar denovo. Isso deve ajudar
          // um pouco na performance j� que buscar o componente n�o � t�o r�pido
          if (LastChild = nil) or (SameText(LastChild.Name, oName) = false) then
          begin
            if SameText(obj.Name, oName) = false then
              objChild:= obj.FindComponent( oName )
            else
              objChild:= obj;
          end else
          begin
            objChild:= LastChild
          end;

          if objChild <> nil then
          begin
            setProperty( objChild, oProp, DecodeTranslatedStr(oValue) );
            LastChild:= objChild;
          end;
        end;
      end;
    end;
    CloseFile(TxtFile);
  end else
  begin
    // Se o arquivo n�o existir mas existir mas o diret�rio
    // dele existir, criamos o arquivo e colocamos nele as
    // strings padr�o do objeto passado
    if directoryExists(ExtractFileDir(fFile)) then
    begin
      AssignFile( TxtFile, fFile );
      Rewrite( TxtFile );
      try
        WriteLn(TxtFile, '# ');
        WriteLn(TxtFile, '# Localization file create by Notes');
        WriteLn(TxtFile, '# ');
        WriteLn(TxtFile, '# * Comments: lines that start with # are ignored by the translator component');
        WriteLn(TxtFile, '# * Messages: lines that start with $ are localizations of messages');
        WriteLn(TxtFile, '#   used in dialogs, errors messages, etc.');
        WriteLn(TxtFile, '# * Lines that do not start with a special character are localizations');
        WriteLn(TxtFile, '#   of Notes propertys like Captions of buttons, Hints, etc.');
        WriteLn(TxtFile, '# ');
        for I:= 0 to obj.ComponentCount - 1 do
        begin
          if obj.Components[I].Name <> '' then
          begin
            if getPropValue(obj.Components[I], 'Caption', oValue) then
              WriteLn(TxtFile, obj.Components[I].Name + '.Caption=' + EncodeStrToTranslation(oValue));
            if getPropValue(obj.Components[I], 'Hint', oValue) then
              WriteLn(TxtFile, obj.Components[I].Name + '.Hint=' + EncodeStrToTranslation(oValue));
          end;
        end;
      finally
        CloseFile(TxtFile);
      end;
    end;
  end;
end;


end.
