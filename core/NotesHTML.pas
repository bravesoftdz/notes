//
//    NotesHTML - v�rias fun��es para lidar com HTML
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
  @abstract(NotesHTML - v�rias fun��es para lidar com HTML.)
  @author(Anderson R. Barbieri <notesnr@ig.com.br>)
*)
unit NotesHTML;

interface

{Converte HTML para texto.<BR>
 @code(EsPtFrSupport) - ativa suporte para l�nguas latinas como portugu�se franc�s.<BR>
 @code(SimbolsSupport) - ativa suporte a s�mbolos como copryright, marca registrada, etc.<BR>
 @code(OtherLangSupport) - ativa suporte para outras linguas. }
function HTML2TXT(S : string; EsPtFrSupport : Boolean; SimbolsSupport : Boolean; OtherLangSupport : Boolean) : string;
{Converte texto para HTML, inclu�ndo caracteres especiais.}
function TXT2HTML(S : string) : string;

implementation

uses
  FastStrings;

function HTML2TXT(S : string; EsPtFrSupport : Boolean; SimbolsSupport : Boolean; OtherLangSupport : Boolean) : string;
var
  X, TagCnt: Integer;
begin
  //this is the Support for english, and the base for other languages
  S := FastReplace(S,'&nbsp;',' ',False);
  S := FastReplace(S,'&amp;','&', False);
  S := FastReplace(S,#13#10,'', False);
  S := FastReplace(S,'<table>',#13#10, False);
  S := FastReplace(S,'</table>',#13#10, False);
  S := FastReplace(S,'<div>',#13#10, False);
  S := FastReplace(S,'</div>',#13#10, False);
  S := FastReplace(S,'<br>',#13#10, False);
  S := FastReplace(S,'<p>',#13#10, False);
  S := FastReplace(S,'</p>',#13#10, False);  //</td></tr>
  S := FastReplace(S,'</tr>',#13#10, False);
  S := FastReplace(S,'<tr>',#13#10, False);
  S := FastReplace(S,'&quot;','"', False);
  S := FastReplace(S,'&copy;','� ',False);
  S := FastReplace(S,'&reg;','�',False);

  //support for spanish, french and portuguese
  if  EsPtFrSupport then begin
    S := FastReplace(S,'&uuml;','�',False);
    S := FastReplace(S,'&uacute;','�',False);
    S := FastReplace(S,'&iexcl;','�',False);
    S := FastReplace(S,'&ouml;','�',False);
    S := FastReplace(S,'&otilde;','�',False);
    S := FastReplace(S,'&ocirc;','�',False);
    S := FastReplace(S,'&oacute;','�',False);
    S := FastReplace(S,'&ograve;','�',False);
    S := FastReplace(S,'&ntilde;','�',False);
    S := FastReplace(S,'&ecirc;','�',False);
    S := FastReplace(S,'&iuml;','�',False);
    S := FastReplace(S,'&iacute;','�',False);
    S := FastReplace(S,'&eacute;','�',False);
    S := FastReplace(S,'&ccedil;','�',False);
    S := FastReplace(S,'&auml;','�',False);
    S := FastReplace(S,'&atilde;','�',False);
    S := FastReplace(S,'&aacute;','�',False);
    S := FastReplace(S,'&agrave;','�',False);
    S := FastReplace(S,'&Uuml;','�',False);
    S := FastReplace(S,'&Ucirc;','�',False);
    S := FastReplace(S,'&Uacute;','�',False);
    S := FastReplace(S,'&Ouml;','�',False);
    S := FastReplace(S,'&Otilde;','�',False);
    S := FastReplace(S,'&Ocirc;','�',False);
    S := FastReplace(S,'&Oacute;','�',False);
    S := FastReplace(S,'&Ntilde;','�',False);
    S := FastReplace(S,'&euml;','�',False);
    S := FastReplace(S,'&Iuml;','�',False);
    S := FastReplace(S,'&Icirc;','�',False);
    S := FastReplace(S,'&Iacute;','�',False);
    S := FastReplace(S,'&Euml;','�',False);
    S := FastReplace(S,'&Ecirc;','�',False);
    S := FastReplace(S,'&Eacute;','�',False);
    S := FastReplace(S,'&Ccedil;','�',False);
    S := FastReplace(S,'&uml;','�',False);
    S := FastReplace(S,'&die;','�',False);
    S := FastReplace(S,'&Auml;','�',False);
    S := FastReplace(S,'&Atilde;','�',False);
    S := FastReplace(S,'&Acirc;','�',False);
    S := FastReplace(S,'&Aacute;','�',False);
    S := FastReplace(S,'&iquest;','�',False);
    S := FastReplace(S,'&bdquo;','�',False);
    S := FastReplace(S,'&rdquo;','�',False);
    S := FastReplace(S,'&ldquo;','�',False);
    S := FastReplace(S,'&sbquo;','�',False);
    S := FastReplace(S,'&rsquo;','�',False);
    S := FastReplace(S,'&lsquo;','�',False);
    S := FastReplace(S,'&shy;','�',False);
    S := FastReplace(S,'&rsaquo;','�',False);
    S := FastReplace(S,'&lsaquo;','�',False);
    S := FastReplace(S,'&Ograve;','�',False);
    S := FastReplace(S,'&Egrave;','�',False);
    S := FastReplace(S,'&Igrave;','�',False);
    S := FastReplace(S,'&ugrave;','�',False);
    S := FastReplace(S,'&icirc;','�',False);
    S := FastReplace(S,'&igrave;','�',False);
    S := FastReplace(S,'&egrave;','�',False);
    S := FastReplace(S,'&Agrave;','�',False);
  end;

  //Support for simbols....
  if SimbolsSupport then begin
    S := FastReplace(S,'&ordf;','�',False);
    S := FastReplace(S,'&deg;','�',False);
    S := FastReplace(S,'&para;','�',False);
    S := FastReplace(S,'&micro;','�',False);
    S := FastReplace(S,'&acute;','�',False);
    S := FastReplace(S,'&sup3;','�',False);
    S := FastReplace(S,'&sup2;','�',False);
    S := FastReplace(S,'&plusmn;','�',False);
    S := FastReplace(S,'&yen;','�',False);
    S := FastReplace(S,'&curren;','�',False);
    S := FastReplace(S,'&pound;','�',False);
    S := FastReplace(S,'&cent;','�',False);
    S := FastReplace(S,'&frac34;','�',False);
    S := FastReplace(S,'&frac12;','�',False);
    S := FastReplace(S,'&frac14;','�',False);
    S := FastReplace(S,'&raquo;','�',False);
    S := FastReplace(S,'&ordm;','�',False);
    S := FastReplace(S,'&sup1;','�',False);
    S := FastReplace(S,'&divide;','�',False);
    S := FastReplace(S,'&middot;','�',False);
    S := FastReplace(S,'&macr;','�',False);
    S := FastReplace(S,'&hibar;','�',False);
    S := FastReplace(S,'&not;','�',False);
    S := FastReplace(S,'&laquo;','�',False);
    S := FastReplace(S,'&brvbar;','�',False);
    S := FastReplace(S,'&brkbar;','�',False);
    S := FastReplace(S,'&mdash;','�',False);
    S := FastReplace(S,'&ndash;','�',False);
    S := FastReplace(S,'&permil;','�',False);
    S := FastReplace(S,'&Dagger;','�',False);
    S := FastReplace(S,'&dagger;','�',False);
  End;

  //Support for other languages....
  if OtherLangSupport then begin
    S := FastReplace(S,'&oslash;','�',False);
    S := FastReplace(S,'&eth;','�',False);
    S := FastReplace(S,'&aelig;','�',False);
    S := FastReplace(S,'&aring;','�',False);
    S := FastReplace(S,'&szlig;','�',False);
    S := FastReplace(S,'&THORN;','�',False);
    S := FastReplace(S,'&Yacute;','�',False);
    S := FastReplace(S,'&Ugrave;','�',False);
    S := FastReplace(S,'&Oslash;','�',False);
    S := FastReplace(S,'&times;','�',False);
    S := FastReplace(S,'&ETH;','�',False);
    S := FastReplace(S,'&AElig;','�',False);
    S := FastReplace(S,'&Aring;','�',False);
    S := FastReplace(S,'&cedil;','�',False);
  end;

  TagCnt := 0;
  Result := '';
  for X := 1 to Length( S ) do
    case S[X] of
      '<' : Inc(TagCnt);
      '>' : Dec(TagCnt);
    else
      if TagCnt <= 0 then begin
        Result := Result + S[X];
        TagCnt := 0;
      end;
    end;
    Result := FastReplace(Result,'&lt;','<', False);
    Result := FastReplace(Result,'&gt;','>', False);
end;

function TXT2HTML(S : string) : string;
begin
  S := FastReplace(S,'<','&lt;', True);
  S := FastReplace(S,'>','&gt;', True);
  S := FastReplace(S,'�','&uuml;',True);
  S := FastReplace(S,'�','&uacute;',True);
  S := FastReplace(S,'�','&iexcl;',True);
  S := FastReplace(S,'�','&ouml;',True);
  S := FastReplace(S,'�','&otilde;',True);
  S := FastReplace(S,'�','&ocirc;',True);
  S := FastReplace(S,'�','&oacute;',True);
  S := FastReplace(S,'�','&ograve;',True);
  S := FastReplace(S,'�','&ntilde;',True);
  S := FastReplace(S,'�','&ecirc;',True);
  S := FastReplace(S,'�','&iuml;',True);
  S := FastReplace(S,'�','&iacute;',True);
  S := FastReplace(S,'�','&eacute;',True);
  S := FastReplace(S,'�','&ccedil;',True);
  S := FastReplace(S,'�','&auml;',True);
  S := FastReplace(S,'�','&atilde;',True);
  S := FastReplace(S,'�','&aacute;',True);
  S := FastReplace(S,'�','&agrave;',True);
  S := FastReplace(S,'�','&acirc;',True);
  S := FastReplace(S,'�','&Uuml;',True);
  S := FastReplace(S,'�','&Ucirc;',True);
  S := FastReplace(S,'�','&Uacute;',True);
  S := FastReplace(S,'�','&Ouml;',True);
  S := FastReplace(S,'�','&Otilde;',True);
  S := FastReplace(S,'�','&Ocirc;',True);
  S := FastReplace(S,'�','&Oacute;',True);
  S := FastReplace(S,'�','&Ntilde;',True);
  S := FastReplace(S,'�','&euml;',True);
  S := FastReplace(S,'�','&Iuml;',True);
  S := FastReplace(S,'�','&Icirc;',True);
  S := FastReplace(S,'�','&Iacute;',True);
  S := FastReplace(S,'�','&Euml;',True);
  S := FastReplace(S,'�','&Ecirc;',True);
  S := FastReplace(S,'�','&Eacute;',True);
  S := FastReplace(S,'�','&Ccedil;',True);
  S := FastReplace(S,'�','&uml;',True);
  S := FastReplace(S,'�','&die;',True);
  S := FastReplace(S,'�','&Auml;',True);
  S := FastReplace(S,'�','&Atilde;',True);
  S := FastReplace(S,'�','&Acirc;',True);
  S := FastReplace(S,'�','&Aacute;',True);
  S := FastReplace(S,'�','&bdquo;',True);
  S := FastReplace(S,'�','&rdquo;',True);
  S := FastReplace(S,'�','&ldquo;',True);
  S := FastReplace(S,'�','&sbquo;',True);
  S := FastReplace(S,'�','&rsquo;',True);
  S := FastReplace(S,'�','&lsquo;',True);
  S := FastReplace(S,'�','&shy;',True);
  S := FastReplace(S,'"','&quot;', True);
  S := FastReplace(S,'�','&copy;',True);
  S := FastReplace(S,'�','&reg;',True);
  S := FastReplace(S,'  ','&nbsp; ',True);
  S := FastReplace(S,'&amp;','&', True);
  Result := S;
End;

end.

