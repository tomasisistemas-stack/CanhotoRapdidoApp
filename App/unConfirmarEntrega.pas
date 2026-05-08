unit unConfirmarEntrega;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.NetEncoding,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Media,
  FMX.MediaLibrary, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList,
  FMX.StdActns, u99Permissions, FMX.Platform,
  System.IOUtils
  {$IFDEF ANDROID}
    ,System.Permissions,
     Androidapi.JNI.JavaTypes,
     Androidapi.JNI.Os,
     Androidapi.Helpers, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  System.Math.Vectors, FMX.Controls3D
  {$ENDIF};

type
  TfrmConfirmarEntrega = class(TForm)
    ltop: TLayout;
    Rectangle1: TRectangle;
    lbTop: TLabel;
    lbottom: TLayout;
    rfundo: TRectangle;
    rConfirmarEntrega: TRectangle;
    ImgConfirmarEntrega: TImage;
    lbConfirmarEntrega: TLabel;
    rCancelarVoltar: TRectangle;
    imgCancelarVoltar: TImage;
    lbCancelarVoltar: TLabel;
    rFoto: TRectangle;
    imgFoto: TImage;
    lbFoto: TLabel;
    Layout1: TLayout;
    imgCanhoto: TImage;
    ActionList: TActionList;
    ActCamera: TTakePhotoFromCameraAction;
    procedure imgCancelarVoltarClick(Sender: TObject);
    procedure ImgConfirmarEntregaClick(Sender: TObject);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFotoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure ResizeImageToMaxSize(var Bitmap: TBitmap; MaxWidth,
      MaxHeight: Integer);
    {$IFNDEF MSWINDOWS}
    procedure MostrarBotoes(prMostrar: Boolean);
    {$ENDIF}

    { Private declarations }
  public
    { Public declarations }
    xIdcliente : integer;
    xCanhoto   : integer;
  end;

var
  frmConfirmarEntrega: TfrmConfirmarEntrega;
  fPermissionCamera: String;
  fScanInProgress: Boolean;
  fFrameTake: Integer;
  fScanBitmap: TBitmap;
  permissao: T99Permissions;

implementation

{$R *.fmx}

uses

  unDMRest, unFuncoes, IdCoderMIME, IdGlobal, unOffline;

procedure TfrmConfirmarEntrega.imgCancelarVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfirmarEntrega.ResizeImageToMaxSize(var Bitmap: TBitmap; MaxWidth, MaxHeight: Integer);
var
  Ratio: Single;
begin
  if (Bitmap.Width > MaxWidth) or (Bitmap.Height > MaxHeight) then
  begin
    // Calculate the scaling ratio
    if Bitmap.Width > Bitmap.Height then
      Ratio := MaxWidth / Bitmap.Width
    else
      Ratio := MaxHeight / Bitmap.Height;

    // Resize the bitmap to fit within the max dimensions
    Bitmap.SetSize(Round(Bitmap.Width * Ratio), Round(Bitmap.Height * Ratio));
  end;
end;



procedure TfrmConfirmarEntrega.ImgConfirmarEntregaClick(Sender: TObject);
var
  DM : TDMRest;
  sParams : TStringList;
  BitMap : TBitmap;
  filePath, fileName: string;
begin
  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;

  fileName := GerarNomeArq('png');
  filePath := TPath.Combine(TPath.GetDocumentsPath, fileName);

  imgCanhoto.Bitmap.SaveToFile(filePath);

  // Prepare parameters to send
  sParams := TStringList.Create;
  sParams.Add('canhoto:' + IntToStr(xCanhoto));
  sParams.Add('cliente_id:' + IntToStr(xIdcliente));
  sParams.Add('foto:' + filename);

  // Call your method to send data (check that server is expecting the parameters correctly)
  DM := TDMRest.Create(nil);
  DM.UploadFile('upload', filePath, fileName);
  DM.Execute('confirmarentrega', 'application/text', sParams);

  DeleteFile(filePath);

  // Cleanup
  sParams.Free;
  DM.Free;

  // Close the form after sending data
  ModalResult := mrOK;
  Close;
end;

procedure TfrmConfirmarEntrega.imgFotoClick(Sender: TObject);
var
  Service: IFMXCameraService;
  Params : TParamsPhotoQuery;
begin
{$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXCameraService,Service) then
  begin
    Params.Editable := True;
    // Specifies whether to save a picture to device Photo Library
    Params.NeedSaveToAlbum := True;
    Params.RequiredResolution := TSize.Create(640, 640);
    Params.OnDidFinishTaking := ActCameraDidFinishTaking;
    Service.TakePhoto(imgFoto, Params);
  end
  else
    ShowMessage('This device does not support the camera service');
{$ENDIF}
end;


{$IFNDEF MSWINDOWS}
procedure TfrmConfirmarEntrega.MostrarBotoes(prMostrar: Boolean);
begin
  lbConfirmarEntrega.visible  := prMostrar;
  lbCancelarVoltar.visible    := prMostrar;
  ImgConfirmarEntrega.visible := prMostrar;
  imgCancelarVoltar.visible   := prMostrar;
  if prMostrar then
    lbFoto.Text := 'Tirar Foto Canhoto'
  else
    lbFoto.Text := 'Gravar Foto';
end;
{$ENDIF}


procedure TfrmConfirmarEntrega.ActCameraDidFinishTaking(Image: TBitmap);
begin
    imgCanhoto.Bitmap := Image;
end;


procedure TfrmConfirmarEntrega.FormActivate(Sender: TObject);
begin
  application.formfactor.Orientations := [TFormOrientation.Landscape];
end;

procedure TfrmConfirmarEntrega.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  application.formfactor.Orientations := [TFormOrientation.Portrait];
  permissao.DisposeOf;
end;

procedure TfrmConfirmarEntrega.FormCreate(Sender: TObject);
var
  VCam, VRead, VWrite: string;
begin
  application.formfactor.Orientations := [TFormOrientation.Landscape];
{$IFDEF ANDROID}
  fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);

  // Request permissions
  VCam := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  VRead := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  VWrite := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  PermissionsService.RequestPermissions([VCam, VRead, VWrite],
                                            procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
                                            var
                                              GR: TPermissionStatus;
                                            begin
                                              for GR in AGrantResults do
                                                if (GR <> TPermissionStatus.Granted) then
                                                  Break;
                                            end
                                         );
    {$ENDIF}
end;

end.
