unit unLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.DialogService,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Ani,
  FMX.Edit, FMX.Objects, System.IOUtils;

type
  TfrmLogin = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    RoundRect1: TRoundRect;
    edUsuario: TEdit;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edSenha: TEdit;
    FloatAnimation1: TFloatAnimation;
    Layout5: TLayout;
    lbLoginResultado: TLabel;
    Layout4: TLayout;
    RRAcessar: TRoundRect;
    lbAcesso: TLabel;
    Layout6: TLayout;
    RoundRect3: TRoundRect;
    cbclientes: TComboBox;
    ltop: TLayout;
    Rectangle1: TRectangle;
    lbTop: TLabel;
    lbottom: TLayout;
    rfundo: TRectangle;
    Rectangle2: TRectangle;
    imgSair: TImage;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    procedure RRAcessarClick(Sender: TObject);
    procedure edUsuarioExit(Sender: TObject);
    procedure ImgSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses

   unDMRest, unPrincipal, unFuncoes, unOffline;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.iPhone55in.fmx IOS}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TfrmLogin.edUsuarioExit(Sender: TObject);
var
  DM : TDMRest;
  sParams : TStringList;
begin
  if Trim(edUsuario.Text) = '' then exit;

  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;


  DM := TDMRest.Create(nil);
  sParams := TStringList.Create;
  sParams.Add('user:' + trim(edUsuario.Text));
  try
    DM.Execute('carregarclientes', 'text/html', sParams);
    cbClientes.Items.Clear;
    cbClientes.ItemIndex := -1;
    if DM.RESTResponse.Content <> 'Erro' then
    begin
      cbClientes.Items.Text := DM.RESTResponse.Content;
      cbClientes.ItemIndex := 0;
    end;
  except
    lbLoginResultado.Visible := true;
    lbLoginResultado.Text := 'Servidor offline';
    exit;
  end;
  sParams.Free;
  DM.free;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  application.formfactor.Orientations := [TFormOrientation.Portrait,
                                          TFormOrientation.Landscape,
                                          TFormOrientation.InvertedPortrait,
                                          TFormOrientation.InvertedLandscape];
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  application.formfactor.Orientations := [TFormOrientation.Portrait];
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  slLogin : TStringList;
begin
  if FileExists(TPath.Combine(TPath.GetDocumentsPath, 'login.txt')) then
  begin
    slLogin := TStringList.Create;
    try
      slLogin.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath, 'login.txt'));
      edUsuario.Text := slLogin.Values['Login'];
      edSenha.Text   := slLogin.Values['Senha'];
      edUsuarioExit(sender);
    finally
      slLogin.free;
    end;
  end;
end;

procedure TfrmLogin.ImgSairClick(Sender: TObject);
begin
  SairdoSistema;
end;

procedure TfrmLogin.RRAcessarClick(Sender: TObject);
var
  DM : TDMRest;
  sParams, sResponse, slLogin : TStringList;
begin
  if not ChecarConexao then
  begin
    if not Assigned(frmOffline) then
      Application.CreateForm(TfrmOffline, frmOffline);
    frmOffline.Show;
    exit;
  end;



  if pos('=', cbclientes.Items[cbclientes.ItemIndex]) = 0 then
  begin
    lbLoginResultado.Visible := true;
    lbLoginResultado.Text := 'Selecione a Empresa!!!';
    exit;
  end;

  DM := TDMRest.Create(nil);
  sParams := TStringList.Create;
  sParams.Add('user:' + trim(edUsuario.Text));
  sParams.Add('password:' + trim(edSenha.Text));

  lbLoginResultado.Visible := True;
  lbLoginResultado.Text := 'Carregando...';

  try
    DM.Execute('login', 'text/html', sParams);
  except
    lbLoginResultado.Visible := true;
    lbLoginResultado.Text := 'Servidor offline';
    exit;
  end;

 if pos('Valido=SIM', DM.RESTResponse.Content) > 0 then
  begin
    if pos('TipoAcesso=Motorista', DM.RESTResponse.Content) = 0 then
    begin
      lbLoginResultado.Visible := true;
      lbLoginResultado.Text := 'Acesso apenas para os usuários Motoristas!';
    end
    else begin

      slLogin := TStringList.Create;
      try
        slLogin.Values['Login'] := edUsuario.Text;
        slLogin.Values['Senha'] := edSenha.Text;
        slLogin.SaveToFile(TPath.Combine(TPath.GetDocumentsPath, 'login.txt'));
      finally
        slLogin.free;
      end;

      if not Assigned(frmPrincipal) then
        Application.CreateForm(TfrmPrincipal, frmPrincipal);

      Application.MainForm := frmPrincipal;
      frmPrincipal.xDadosusuario := DM.RESTResponse.Content;
      frmPrincipal.xIdcliente := StrToInt(copy(cbclientes.Items[cbclientes.ItemIndex] ,  pos('=', cbclientes.Items[cbclientes.ItemIndex])+1, 10));

      frmPrincipal.show;
      frmLogin.Close;
    end;
  end
  else
  begin
    lbLoginResultado.Visible := true;
    lbLoginResultado.Text := 'Login Inválido!';
  end;
  sParams.Free;
  DM.free;
end;


end.
