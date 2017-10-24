unit XGServices;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, LibXmlParser, Graphics,
  strUtils, ExtCtrls, XGUtils, XG;

type

  { Interface que todos os servi�os devem implementar.  }
  IXgService = interface(IInterface)
  ['{6A8DD925-7060-4079-9B9C-10AFD1B4B74C}']
    // Chamado assim que o XG percebe que se trata de um servi�o
    procedure InitService(const XG: TXG; const Bind: TComponent;
      const xml: TXMlParser);
    // Chamado quando o XG termina de ler as proprieades do servi�o
    procedure endReadServicePropertys;
    // Chamado quando o XG termina de ler todo o arquivo XML
    procedure endReadPage(Var CanFree: boolean);
    // Permite ao servi�o proibir que multiplas inst�ncias de si mesmo
    // sejam criadas. Se o servi�o proibir m�ltiplas inst�ncias, ao inv�s
    // de criar uma nova inst�ncia, XG ir� apenas chamar InitService novamente
    // e reler as propriedades da �ninca inst�ncia j� criada. Servi�os que
    // possuem inst�ncias �nicas ganham o nome de sua pr�pria tag e podem assim
    // ser referenciados usando ela.
    function  allowMultipleInstances: boolean;
  end;


//function isXgService(const tagName: string): boolean; overload;
function isXgService(const obj: TComponent): boolean; //overload;

implementation

function isXgService(const obj: TComponent): boolean;
begin
  Result:= false;
//  if obj is TXgDrawingService then
//    Result:= true;
  if obj.GetInterfaceEntry(StringToGUID('{6A8DD925-7060-4079-9B9C-10AFD1B4B74C}')) <> nil then
    Result:= true;
end;




{
  TXgDrawingService - servi�o de desenho :)

  TXgTranslationService - servi�o de tradu��o
    cada string traduzida � uma var

  TXgHTTPService - baixa arquivos da internet

  TXgXMLReaderService

  TXgSimpleScriptService

  TXgFileReaderService

  TXgFileSearchService

}
end.