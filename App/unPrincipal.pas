unit unPrincipal;

interface

uses

  {$IFDEF ANDROID}
    System.Android.Service,
    ServiceUnit,
  {$ENDIF}
  System.Classes, System.Messaging, System.Permissions, System.Sensors,
  FMX.Controls, FMX.Controls.Presentation, FMX.Forms, FMX.Platform, FMX.StdCtrls, FMX.Types,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FMX.Objects, FMX.ListBox, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Graphics, Data.Bind.Components, Data.Bind.DBScope,


  System.SysUtils, System.Types, System.UITypes, System.Variants, System.DateUtils,
  FMX.Dialogs,
  FMX.Edit, FMX.Media, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.DateTimeCtrls,
  System.ImageList, FMX.ImgList,
  System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Controls,
  Fmx.Bind.Navigator, System.Sensors.Components, u99Permissions,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfrmPrincipal = class(TForm)
    BindingsList1: TBindingsList;
    BindSourceDBEntregas: TBindSourceDB;
    Brush1: TBrushObject;
    FDMemTableEntregas: TFDMemTable;
    FDMemTableEntregasnumeroNota: TIntegerField;
    FDMemTableEntregasdataNota: TDateTimeField;
    FDMemTableEntregasdestinatario: TStringField;
    FDMemTableEntregascnpjCpf: TStringField;
    FDMemTableEntregaslogradouro: TStringField;
    FDMemTableEntregasnumero: TStringField;
    FDMemTableEntregasnomCidade: TStringField;
    FDMemTableEntregasuf: TStringField;
    FDMemTableEntregasordemEntrega: TIntegerField;
    FDMemTableEntregasid: TIntegerField;
    FDMemTableEntregasentregue: TStringField;
    ImgCheck: TImage;
    Layout2: TLayout;
    tcMenu: TTabControl;
    tbMenus: TTabItem;
    tbEntregas: TTabItem;
    lvEntregas: TListBox;
    ListBoxItem1: TListBoxItem;
    Layout3: TLayout;
    Rectangle3: TRectangle;
    rFoto: TRectangle;
    imgFoto: TImage;
    lbFoto: TLabel;
    rGPS: TRectangle;
    imgGPS: TImage;
    lbGPS: TLabel;
    rAtualizar: TRectangle;
    ImgAtualizar: TImage;
    lbAtualizar: TLabel;
    lbottom: TLayout;
    rfundo: TRectangle;
    rEntregas: TRectangle;
    ImEntregas: TImage;
    lbEntregas: TLabel;
    rMenus: TRectangle;
    ImMenus: TImage;
    lbMenus: TLabel;
    rSair: TRectangle;
    imSair: TImage;
    Label1: TLabel;
    ltop: TLayout;
    Rectangle1: TRectangle;
    lbMenu: TLabel;
    imgMenu: TImage;
    StyleBook1: TStyleBook;
    lyUser: TLayout;
    lbNomeUsuario: TLabel;
    lyComissoes: TLayout;
    Rectangle2: TRectangle;
    lyComissaoTitulo: TLayout;
    lbComissoes: TLabel;
    lyDashboard: TLayout;
    lyDashRow1: TLayout;
    rDashEntregas: TRectangle;
    lbDashEntregas: TLabel;
    lbDashEntregasValor: TLabel;
    rDashComEnt: TRectangle;
    lbDashComEntregas: TLabel;
    lbDashComEntregasValor: TLabel;
    lyDashRow2: TLayout;
    rDashKm: TRectangle;
    lbDashKm: TLabel;
    lbDashKmValor: TLabel;
    rDashComKm: TRectangle;
    lbDashComKm: TLabel;
    lbDashComKmValor: TLabel;
    lyDashRow3: TLayout;
    rDashTotal: TRectangle;
    lbDashTotal: TLabel;
    lbDashTotalValor: TLabel;
    lyFiltro: TLayout;
    dtIni: TDateEdit;
    dtFim: TDateEdit;
    btDashFiltrar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rMenusClick(Sender: TObject);
    procedure rEntregasClick(Sender: TObject);
    procedure rSairClick(Sender: TObject);
    procedure imSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rEntregasTap(Sender: TObject; const Point: TPointF);
    procedure rMenusTap(Sender: TObject; const Point: TPointF);
    procedure RadioEntregaChange(Sender: TObject);
    procedure btDashFiltrarClick(Sender: TObject);
    procedure imgGPSClick(Sender: TObject);
    procedure ImgAtualizarClick(Sender: TObject);
    procedure imgFotoClick(Sender: TObject);
  private
    {$IFDEF ANDROID}
    ServiceConnection: TLocalServiceConnection;
    Service: TLocationTrackingModule;

    procedure ServiceConnected(const LocalService: TAndroidBaseService);
    procedure ServiceDisconnected;
    function HandleApplicationEvent(ApplicationEvent: TApplicationEvent; Context: TObject): Boolean;
    procedure StartLocationTracking;
    procedure StopLocationTracking;
    procedure ServiceLocationUpdated(const NewLocation: TLocationCoord2D);
    procedure OpenGoogleMapsAndroid;
  {$ENDIF}
    procedure CarregarMenu(Menu: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ListarEntregas;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListarComissoes;
  public
    { Public declarations }
    xIdcliente : integer;
    xDadosusuario : String;
    xNomeUsuario: String;
    xVeiculoId: String;
    xProximoCanhoto: integer;
    xProximoEndereco: String;
  end;

var
  frmPrincipal: TfrmPrincipal;
  img : Timage;
  edcodebar : tedit;
  permissao: T99Permissions;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses
  FMX.DialogService, unConfirmarEntrega, unOffline,

{$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App, FMX.Helpers.Android,
  Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os, Androidapi.JNI.Widget,
  Androidapi.JNI.Net,
{$ENDIF}

{$IFDEF IOS}
  iOSapi.Foundation, FMX.Helpers.iOS,
  iOSapi.UIKit,
{$ENDIF}

  unDMRest,
  unFuncoes,
  unLogin;


procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
  ServiceConnection := TLocalServiceConnection.Create;
  ServiceConnection.OnConnected := ServiceConnected;
  ServiceConnection.OnDisconnected := ServiceDisconnected;

  var ApplicationEventService: IFMXApplicationEventService;

  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, ApplicationEventService) then
    ApplicationEventService.SetApplicationEventHandler(HandleApplicationEvent);
  {$ENDIF}
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  {$IFDEF ANDROID}
  StopLocationTracking;
  ServiceConnection.Free;
  {$ENDIF}
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  sDadosusuario : TStringList;
begin
  sDadosusuario := TStringList.Create;
  try
    sDadosusuario.Text := xDadosusuario;
    xVeiculoId := Trim(sDadosusuario.Values['IdMotorista']);
    xNomeUsuario := Trim(sDadosusuario.Values['usuario_nome']);

    if xNomeUsuario <> '' then
      lbNomeUsuario.Text := 'Bem-vindo ' + xNomeUsuario
    else
      lbNomeUsuario.Text := 'Bem-vindo';
  finally
    sDadosusuario.Free;
  end;

  dtIni.Date := EncodeDate(YearOf(Date), MonthOf(Date), 1);
  dtFim.Date := Date;
  try
    ListarComissoes;
  except
    on E: Exception do
      TDialogService.ShowMessage('Falha ao carregar tela inicial: ' + E.Message);
  end;

  {$IFDEF ANDROID}
  // Tracking the user's location requires either the 'ACCESS_COARSE_LOCATION' dangerous permission or the 'ACCESS_FINE_LOCATION'
  // one to be granted at runtime.
  TPermissionsService.DefaultService.RequestPermissions(
    [JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION), JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)],
    procedure(const Permissions: TClassicStringDynArray; const GrantResults: TClassicPermissionStatusDynArray)
    begin
      if (Length(GrantResults) = 2) and ((GrantResults[0] = TPermissionStatus.Granted) or (GrantResults[1] = TPermissionStatus.Granted)) then
        StartLocationTracking;
    end,
    procedure(const Permissions: TClassicStringDynArray; const PostRationaleProc: TProc)
    begin
      TDialogService.ShowMessage('The location permission is needed for tracking the user''s location',
      procedure(const &Result: TModalResult)
      begin
        PostRationaleProc;
      end);
    end);
  {$ENDIF}
end;

procedure TfrmPrincipal.CarregarMenu(Menu:Integer);
begin
  rMenus.Opacity := 0.4;
  rEntregas.Opacity := 0.4;


  case menu of
     1 : begin
       rMenus.Opacity := 1;
       lbMenu.Text := lbMenus.Text;
       imgMenu.Bitmap := ImMenus.Bitmap;
       tcMenu.ActiveTab := tbMenus;
     end;
     2 : begin
       rEntregas.Opacity := 1;
       lbMenu.Text := lbEntregas.Text;
       imgMenu.Bitmap := ImEntregas.Bitmap;
       tcMenu.ActiveTab := tbEntregas;
     end;
  end;
end;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
begin
  ListarEntregas;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  application.formfactor.Orientations := [TFormOrientation.Portrait,
                                          TFormOrientation.Landscape,
                                          TFormOrientation.InvertedPortrait,
                                          TFormOrientation.InvertedLandscape];
end;

{$IFDEF ANDROID}
procedure TfrmPrincipal.ServiceConnected(const LocalService: TAndroidBaseService);
begin
  // Called when the connection between the native activity and the service has been established. It is used to obtain the
  // binder object that allows the direct interaction between the native activity and the service.
  Service := TLocationTrackingModule(LocalService);
  Service.LocationUpdated := ServiceLocationUpdated;
end;

procedure TfrmPrincipal.OpenGoogleMapsAndroid;
var
  Intent: JIntent;
  Uri: Jnet_Uri;  // Use JUri, not Jnet.Uri
begin
  showmessage('teste');
  // Create the intent with action VIEW
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);

  // Format the geo: URI for Google Maps
  Uri := TJnet_Uri.JavaClass.parse(StringToJString('google.navigation:q='+xProximoEndereco));

  // Set the data for the intent (the geo URL)
  Intent.setData(Uri);
  Intent.setPackage(StringToJString('com.google.android.apps.maps'));

  // Start the activity (Google Maps app or browser)
  TAndroidHelper.Activity.startActivity(Intent);
end;
{$ENDIF}


{$IFDEF IOS}
procedure TfrmPrincipal.OpenGoogleMapsIOS;
var
  URL: NSURL;
begin
  // Convert the Delphi string to NSString using Create method
  URL := TNSURL.Wrap(TNSURL.OCClass.URLWithString(NSStr('google.navigation:q=' + xProximoEndereco)));  // Convert the Delphi string to NSString

  // Open the URL with the Google Maps app (or default browser if Google Maps is not installed)
  TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication).openURL(URL);
end;
  {$ENDIF}




procedure TfrmPrincipal.btDashFiltrarClick(Sender: TObject);
begin
  ListarComissoes;
end;

procedure TfrmPrincipal.imgFotoClick(Sender: TObject);
begin
  if not Assigned(frmConfirmarEntrega) then
    Application.CreateForm(TfrmConfirmarEntrega, frmConfirmarEntrega);
  frmConfirmarEntrega.xIdcliente := xIdcliente;
  frmConfirmarEntrega.xCanhoto := xProximoCanhoto;
  frmConfirmarEntrega.Show;
end;

procedure TfrmPrincipal.imgGPSClick(Sender: TObject);
begin
    {$IFDEF IOS}
    OpenGoogleMapsIOS;
   {$ENDIF}
    {$IFDEF ANDROID}
   OpenGoogleMapsAndroid;
    {$ENDIF}
end;

procedure TfrmPrincipal.imSairClick(Sender: TObject);
begin
  SairdoSistema;
end;

procedure TfrmPrincipal.ListarComissoes;
var
  DM : TDMRest;
  sParams : TStringList;
  y, m, d: Word;
  dtIniVal, dtFimVal: TDate;
begin
  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;

  if (dtIni.Text <> '') then
    dtIniVal := DateOf(dtIni.Date)
  else
  begin
    DecodeDate(Date, y, m, d);
    dtIniVal := EncodeDate(y, m, 1);
  end;

  if (dtFim.Text <> '') then
    dtFimVal := DateOf(dtFim.Date)
  else
    dtFimVal := Date;

  if dtFimVal < dtIniVal then
  begin
    ShowMessage('Data final deve ser maior ou igual a data inicial.');
    Exit;
  end;

  sParams := TStringList.Create;
  DM := TDMRest.Create(nil);
  try
    sParams.Add('cliente_id:' + IntToStr(xIdcliente));
    sParams.Add('data_ini:' + FormatDateTime('dd/mm/yyyy', dtIniVal));
    sParams.Add('data_fim:' + FormatDateTime('dd/mm/yyyy', dtFimVal));
    sParams.Add('motorista_id:' + xVeiculoId);

    DM.Execute('comissoes', 'application/json', sParams);
    if Assigned(DM.FDMemTable) and DM.FDMemTable.Active and (not DM.FDMemTable.IsEmpty) then
    begin
      DM.FDMemTable.First;
      lbDashEntregasValor.Text := DM.FDMemTable.FieldByName('ENTREGAS').AsString;
      lbDashComEntregasValor.Text := FormatFloat('R$ #,##0.00', DM.FDMemTable.FieldByName('COMISSAOENTREGASVALOR').AsFloat);
      lbDashKmValor.Text := DM.FDMemTable.FieldByName('KM').AsString;
      lbDashComKmValor.Text := FormatFloat('R$ #,##0.00', DM.FDMemTable.FieldByName('COMISSAOKMVALOR').AsFloat);
      lbDashTotalValor.Text := FormatFloat('R$ #,##0.00', DM.FDMemTable.FieldByName('TOTALCOMISSAO').AsFloat);
    end
    else
    begin
      lbDashEntregasValor.Text := '0';
      lbDashComEntregasValor.Text := 'R$ 0,00';
      lbDashKmValor.Text := '0';
      lbDashComKmValor.Text := 'R$ 0,00';
      lbDashTotalValor.Text := 'R$ 0,00';
    end;
  finally
    DM.Free;
    sParams.Free;
  end;
end;

procedure TfrmPrincipal.RadioEntregaChange(Sender: TObject);
var
  i: Integer;
  item: TListBoxItem;
  rb: TRadioButton;
begin
  if not (Sender is TRadioButton) then
    Exit;
  rb := TRadioButton(Sender);
  if not rb.IsChecked then
    Exit;
  if rb.Tag <> 0 then
    xProximoCanhoto := rb.Tag
  else
    xProximoCanhoto := StrToIntDef(rb.TagString, 0);
  xProximoEndereco := rb.Hint;
  for i := 0 to lvEntregas.Count - 1 do
  begin
    item := lvEntregas.ItemByIndex(i);
    if Assigned(item) and (item.TagObject is TRadioButton) then
    begin
      if item.TagObject <> rb then
        TRadioButton(item.TagObject).IsChecked := False;
    end;
  end;
end;

procedure TFrmPrincipal.ListarEntregas;
var
  DM : TDMRest;
  sParams : TStringList;
  Item: TListBoxItem;
  rbEntrega: TRadioButton;
begin
  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;

  sParams := TStringList.Create;
  DM := TDMRest.Create(nil);
  try
    sParams.Add('veiculo_id:' + Trim(xVeiculoId));
    sParams.Add('cliente_id:' + IntToStr(xIdcliente));

    DM.Execute('listaentregas', 'application/json', sParams);
    if not (Assigned(DM.FDMemTable) and DM.FDMemTable.Active and (not DM.FDMemTable.IsEmpty)) then
      Exit;

    FDMemTableEntregas.Active := True;
    FDMemTableEntregas.CopyDataSet(DM.FDMemTable, [coRestart, coAppend]);

    xProximoCanhoto := 0;

    lvEntregas.Clear;
    lvEntregas.BeginUpdate;
    try
      FDMemTableEntregas.First;
      while not FDMemTableEntregas.Eof do
      begin
        Item := TListBoxItem.Create(lvEntregas);
        Item.Height := 120;

        rbEntrega := TRadioButton.Create(Item);
        rbEntrega.Parent := Item;
        rbEntrega.Align := TAlignLayout.Right;
        rbEntrega.Width := 28;
        rbEntrega.Margins.Right := 8;
        rbEntrega.Margins.Top := 40;
        rbEntrega.Margins.Bottom := 40;
        rbEntrega.IsChecked := False;
        rbEntrega.OnChange := RadioEntregaChange;
        rbEntrega.Tag := FDMemTableEntregasnumeronota.AsInteger;
        rbEntrega.Hint := FDMemTableEntregasLogradouro.AsString + ',' + FDMemTableEntregasNumero.AsString + ',' +
                          FDMemTableEntregasnomCidade.AsString + ',' + FDMemTableEntregasuf.AsString;

        Item.TagObject := rbEntrega;

        if FDMemTableEntregasentregue.AsString = 'T' then
          Item.StyleLookup := 'ListBoxItem1Style2'
        else
          Item.StyleLookup := 'ListBoxItem1Style1';

        Item.StylesData['lbOrdem'] := 'Ordem No: ' + FDMemTableEntregasordemEntrega.AsString;
        Item.StylesData['lbNumeroNota'] := 'Canhoto No: ' + FDMemTableEntregasnumeronota.AsString;
        Item.StylesData['lbDestinatario'] := FDMemTableEntregasdestinatario.AsString;
        Item.StylesData['lbEndereco'] := 'End.: ' + FDMemTableEntregasLogradouro.AsString + ', ' + FDMemTableEntregasNumero.AsString;
        Item.StylesData['lbcidadeuf'] := 'Cidade/UF: ' + FDMemTableEntregasnomCidade.AsString + '-' + FDMemTableEntregasUF.AsString;

        if FDMemTableEntregasentregue.AsString = 'T' then
          Item.StylesData['lbstatus'] := 'Status: ENTREGUE'
        else
          Item.StylesData['lbstatus'] := 'Status: A ENTREGAR';

        if (FDMemTableEntregasentregue.AsString <> 'T') and (xProximoCanhoto = 0) then
        begin
          xProximoCanhoto := FDMemTableEntregasnumeronota.AsInteger;
          xProximoEndereco := FDMemTableEntregasLogradouro.AsString + ',' + FDMemTableEntregasNumero.AsString + ',' +
                              FDMemTableEntregasnomCidade.AsString + ',' + FDMemTableEntregasuf.AsString;
        end;

        lvEntregas.AddObject(Item);
        FDMemTableEntregas.Next;
      end;
    finally
      lvEntregas.EndUpdate;
    end;
  finally
    DM.Free;
    sParams.Free;
  end;
end;

{$IFDEF ANDROID}
procedure TfrmPrincipal.ServiceDisconnected;
begin
  // Called when the connection between the native activity and the service has been unexpectedly lost (e.g. when the user
  // manually stops the service using the 'Settings' system application).
  Service := nil;
end;


function TfrmPrincipal.HandleApplicationEvent(ApplicationEvent: TApplicationEvent; Context: TObject): Boolean;
begin
  // It is important to note that a FireMonkey application for Android generally consists of a single activity, which is the
  // native activity mentioned in this demo application. When the native activity starts to be visible (goes to the foreground
  // state), it binds to the service, and when the native activity stops to be visible (goes to the background state), it
  // unbinds from the service. This is needed to allow the service to be aware of the native activity's lifecycle changes.
  // The 'WillBecomeForeground' and 'EnteredBackground' enum cases are equivalent to the 'onStart' and 'onStop' activity
  // lifecycle callbacks.
  case ApplicationEvent of
    TApplicationEvent.WillBecomeForeground:
    begin
      // Binding the native activity to the service turns the service into a bound service and, therefore, allows the native
      // activity to directly interact with it using the binder object passed as parameter in the 'ServiceConnected' procedure.
      ServiceConnection.BindService(TLocationTrackingModule.ServiceClassName);

      Result := True;
    end;
    TApplicationEvent.EnteredBackground:
    begin
      if Service <> nil then
      begin
        // Unbinding the native activity from the service ensures that the native activity is no longer a bound client and the
        // service can be destroyed by the system, as the native activity is the only bound client used in this demo application.
        // If the service is also a started service, the system will destroy the service only after a call to the 'stopSelf'
        // procedure.
        ServiceConnection.UnbindService;

        Service := nil;
      end;

      Result := True;
    end;
  else
    Result := False;
  end
end;

{$ENDIF}


procedure TfrmPrincipal.ImgAtualizarClick(Sender: TObject);
begin
  ListarEntregas;
end;

procedure TfrmPrincipal.rEntregasClick(Sender: TObject);
begin
  CarregarMenu(2);
  ListarEntregas;
end;

procedure TfrmPrincipal.rEntregasTap(Sender: TObject; const Point: TPointF);
begin
  CarregarMenu(2);
  ListarEntregas;
end;

procedure TfrmPrincipal.rMenusClick(Sender: TObject);
begin
  CarregarMenu(1);
end;


procedure TfrmPrincipal.rMenusTap(Sender: TObject; const Point: TPointF);
begin
  CarregarMenu(1);
end;

procedure TfrmPrincipal.rSairClick(Sender: TObject);
begin
  SairdoSistema;
end;

{$IFDEF ANDROID}
procedure TfrmPrincipal.StartLocationTracking;
begin
  if Service <> nil then
    Service.StartLocationTracking;
end;

procedure TfrmPrincipal.StopLocationTracking;
begin
  if Service <> nil then
    Service.StopLocationTracking;
end;

procedure TfrmPrincipal.ServiceLocationUpdated(const NewLocation: TLocationCoord2D);
var
  DM : TDMRest;
  sParams : TStringList;
begin
  var Text := Format('Current location: (%.7f,%.7f)', [NewLocation.Latitude, NewLocation.Longitude], TFormatSettings.Invariant);

  // When the native activity is visible, location updates are presented to the user in toast messages of short duration.
  TJToast.JavaClass.makeText(TAndroidHelper.Context, StrToJCharSequence(Text), TJToast.JavaClass.LENGTH_SHORT).show;

  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;

  sParams := TStringList.Create;
  sParams.Add('veiculo_id:' + trim(xVeiculoId));
  sParams.Add('data_hora:' +  FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
  sParams.Add('latitude:' +  NewLocation.Latitude.ToString);
  sParams.Add('longitude:' +  NewLocation.Longitude.ToString);

  DM := TDMRest.Create(nil);
  DM.Execute('gravargeolocalizacao', 'text/html', sParams);
  DM.free;
  sParams.Free;
end;
{$ENDIF}
end.










