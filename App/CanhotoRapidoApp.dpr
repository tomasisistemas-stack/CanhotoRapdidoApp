program CanhotoRapidoApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  {$IFDEF ANDROID}
  ServiceUnit in '..\Service\ServiceUnit.pas' {LocationTrackingModule: TAndroidService},
    {$ENDIF}
  unPrincipal in 'unPrincipal.pas' {frmPrincipal},
  u99Permissions in 'u99Permissions.pas',
  unConfirmarEntrega in 'unConfirmarEntrega.pas' {frmConfirmarEntrega},
  unDMRest in 'unDMRest.pas',
  unFuncoes in 'unFuncoes.pas',
  unLogin in 'unLogin.pas' {frmLogin},
  unOffline in 'unOffline.pas' {frmOffline};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDMRest, DMRest);
  Application.Run;

end.
