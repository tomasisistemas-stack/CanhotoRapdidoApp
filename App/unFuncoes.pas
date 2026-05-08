unit unFuncoes;

interface

uses
  System.SysUtils,
  System.IOUtils,
  FMX.Forms,
  System.Generics.Collections,
  FMX.Objects,
  System.Classes,
  System.NetEncoding,
  FMX.Graphics,
  Soap.EncdDecd,
  FMX.DialogService,
  System.UITypes;

procedure killApp;
function ChecarConexao: Boolean;
function EncodeBase64(const texto: string): string;
function DecodeBase64(const texto: string): string;
function Base64FromBitmap(Bitmap: TBitmap): string;
function BitmapFromBase64(const base64: string): TBitmap;
function GerarNomeArq(extensao: string): string;
procedure SairdoSistema;

implementation

uses
unDMRest
{$IFDEF ANDROID}
  , Posix.Unistd,
  IdURI,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.Os,
  Androidapi.IOUtils,
  Androidapi.Jni.App,
  FMX.Helpers.Android,
  FMX.Platform
{$ENDIF};

procedure killApp;
{$IFDEF ANDROID}
var
  Intent: JIntent;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  Intent := TJIntent.Create;
  try
    Intent := TAndroidHelper.Activity.getPackageManager.getLaunchIntentForPackage(StringToJString('com.embarcadero.mensorlab'));
    TAndroidHelper.Activity.finishAndRemoveTask;
  except
  end;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Application.Terminate;
  {$ENDIF}
  {$IFDEF IOS}
   Halt(1);
  {$ENDIF}
end;


procedure SairdoSistema;
begin
  TDialogService.MessageDialog('Confirmar a saída do sistema?', System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], System.UITypes.TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrYes:
        begin
          {$IFDEF MSWINDOWS}
            Application.Terminate;
          {$ELSE}
            killApp;
          {$ENDIF}
        end;
      end;
    end);
end;

function ChecarConexao: Boolean;
var
  DM : TDMRest;
  sParams : TStringList;
begin
  sParams := TStringList.Create;
  DM := TDMRest.Create(nil);
  DM.Execute('ping', 'text/html', sParams);
  Result := DM.RESTResponse.Content ='OK';
  DM.free;
  sParams.Free;
end;

function EncodeBase64(const texto: string): string;
var
  obj: TBase64Encoding;
begin
  obj := TBase64Encoding.Create;
  try
    Result := obj.Encode(texto);
  finally
    obj.Free;
  end;
end;

function DecodeBase64(const texto: string): string;
var
  obj: TBase64Encoding;
begin
  obj := TBase64Encoding.Create;
  try
    Result := obj.Decode(texto);
  finally
    obj.Free;
  end;
end;


function Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                        Soap.EncdDecd.EncodeStream(Input, Output);
                        Result := Output.DataString;
                finally
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;


function BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.Free;
                end;
        finally
                Input.Free;
        end;
end;

function GerarNomeArq(extensao: string): string;
begin
    Result := FormatDateTime('yymmddhhnnsszzz', Now) + '.' + extensao;
end;

end.
