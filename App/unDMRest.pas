unit unDMRest;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope,FMX.DIALOGS, IdHTTP;

type
  TDMRest = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FDMemTable: TFDMemTable;
  private
    procedure CleartoDefaults;
    { Private declarations }
  public
    { Public declarations }
    function Execute(const AEndPoint : string; AContentType : string; AParams : TStringList; ARequestMethod : TRestRequestMethod = rmGET): boolean;
    function UploadFile(const AEndPoint: string; const AFilePath: string; const AFileName: string): Boolean;
  end;

var
  DMRest: TDMRest;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

const
   //C_BASE_URL = 'http://216.245.209.43';
  // C_BASE_URL = 'http://192.168.1.2';
   C_BASE_URL = 'http://playlog.ddns.com.br';
  // C_BASE_URL = 'http://186.237.148.138';
   C_PORTA = 9000;

procedure TDMRest.CleartoDefaults;
begin
    RESTClient.ResettoDefaults;
    RESTRequest.ResettoDefaults;
    RESTResponse.ResettoDefaults;
end;

function TDMRest.Execute(const AEndPoint : string; AContentType: string; AParams : TStringList; ARequestMethod : TRestRequestMethod = rmGET): boolean;
var
  x : integer;
  RequestParam : TRESTRequestParameter;
  NomeParam, ValorParam : string;
begin
  try
    CleartoDefaults;
    //application/json, text/plain; q=0.9, text/html;q=0.8,
    RESTResponse.ContentType := AContentType;
    RESTClient.BaseURL := format('%s:%d/%s',[C_BASE_URL, C_PORTA, AEndPoint]);

    RESTRequest.Method := ARequestMethod;
    if AParams.Text <> '' then
    begin
      for x := 0 to AParams.Count - 1 do
      begin
        NomeParam  := copy(AParams[x], 1, pos(':', aParams[x])-1);
        ValorParam := copy(AParams[x], pos(':', aParams[x])+1, 15000);
        RequestParam := RESTRequest.Params.AddItem;
        RequestParam.Name  := NomeParam;
        RequestParam.Value :=ValorParam;

        if AContentType = 'text/html' then
          RequestParam.ContentType := ctTEXT_HTML;

        if AContentType = 'application/json' then
          RequestParam.ContentType := ctAPPLICATION_JSON;

        RequestParam.kind := pkQUERY;
      end;
    end;

    if AContentType = 'application/json' then
      RESTResponseDataSetAdapter.Response := RESTResponse;

    RESTRequest.Execute;

    Result := RESTResponse.StatusCode = 201;
  except
    on e: Exception do
    begin
      //SHOWMESSAGE(E.Message);
    end;

  end;
end;


function TDMRest.UploadFile(const AEndPoint: string; const AFilePath: string; const AFileName: string): Boolean;
var
  FileStream: TFileStream;
  RequestParam: TRESTRequestParameter;
  FidHTTP : TidHTTP;
  FURL: string;
begin
  Result := False;
  try
    // Create the file stream for the file to be uploaded
    FileStream := TFileStream.Create(AFilePath, fmOpenRead);
    try
      // Set the URL for the request
      FURL := Format('%s:%d/%s', [C_BASE_URL, C_PORTA, AEndPoint+'?file='+AFileName]);
      FidHTTP := TidHTTP.Create(nil);
      FidHTTP.Request.ContentType := 'application/octet-stream';
      FidHTTP.Post(FURL, FileStream);
      Result := (FidHTTP.ResponseCode = 200);

    finally
      FileStream.Free;  // Ensure the file stream is freed
      FidHTTP.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error: ' + E.Message);  // Show error message if something goes wrong
    end;
  end;
end;



end.
