unit unMapRouter;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Maps,
  System.Net.HttpClient, System.Net.URLClient, System.JSON, System.Generics.Collections,
  System.Sensors, System.Sensors.Components, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.Net.HttpClientComponent,
  FMX.WebBrowser, System.IOUtils,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App, FMX.Helpers.Android,
  Androidapi.Helpers, Androidapi.JNI.Net, Androidapi.JNI.JavaTypes;


type
  TfrmMapRouter = class(TForm)
    lbottom: TLayout;
    rfundo: TRectangle;
    rVoltar: TRectangle;
    imgVoltar: TImage;
    lbVoltar: TLabel;
    LocationSensor: TLocationSensor;
    HttpClient: TNetHTTPClient;
    WebBrowser1: TWebBrowser;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMarkers: TList<TMapMarker>;  // List to store added markers
    FRouteCoordinates: TList<TMapCoordinate>;  // List to store route waypoints
    procedure FormCreate(Sender: TObject);
    procedure OpenGoogleMapsAndroid;
//    procedure MontaMapa;
//    procedure GetRoute(StartAddress, EndAddress: string);

    { Private declarations }
  public
    { Public declarations }
    xEndereco : string;
  end;

var
  frmMapRouter: TfrmMapRouter;

implementation

{$R *.fmx}

const
  GoogleAPIKey = 'YOUR_GOOGLE_MAPS_API_KEY';  // Replace with your API key

procedure TfrmMapRouter.FormCreate(Sender: TObject);
begin
  // Initialize the markers and route coordinates lists
  FMarkers := TList<TMapMarker>.Create;
  FRouteCoordinates := TList<TMapCoordinate>.Create;

  // Start location sensor to get the current GPS position
  LocationSensor.Active := True;
end;


procedure TfrmMapRouter.FormShow(Sender: TObject);
begin
 { WebBrowser1.URL := 'https://www.google.com.br/maps/dir/?api=1&destination=RUA BRUSQUE, 500, ITAJAI, SC';
  WebBrowser1.Navigate;}

//  ShellExecute(0, 'open', 'googlemaps://?q=latitude,longitude', nil, nil, SW_SHOWNORMAL);
  OpenGoogleMapsAndroid;
end;


procedure TfrmMapRouter.OpenGoogleMapsAndroid;
var
  Intent: JIntent;
  Uri: Jnet_Uri;  // Use JUri, not Jnet.Uri
begin
  // Create the intent with action VIEW
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);

  // Format the geo: URI for Google Maps
  Uri := TJnet_Uri.JavaClass.parse(StringToJString('google.navigation:q=RUA BRUSQUE, 500, ITAJAI, SC'));

  // Set the data for the intent (the geo URL)
  Intent.setData(Uri);

  // Start the activity (Google Maps app or browser)
  TAndroidHelper.Activity.startActivity(Intent);
end;


{
procedure TfrmMapRouter.GetRoute(StartAddress, EndAddress: string);
var
  URL: string;
  Response: IHTTPResponse;
  JsonResponse: TJSONObject;
  Routes: TJSONArray;
begin
  // Construct the Google Maps API URL for Directions API
  URL := Format('https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&key=%s',
                [StartAddress, EndAddress, GoogleAPIKey]);

  try
    // Send HTTP request to Google Directions API
    Response := HttpClient.Get(URL);

    if Response.StatusCode = 200 then
    begin
      // Parse the JSON response
      JsonResponse := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;

      // Get the 'routes' part of the response
      Routes := JsonResponse.GetValue('routes') as TJSONArray;

      // Display the route on the map
      DisplayRouteOnMap(Routes);
    end
    else
    begin
      ShowMessage('Failed to get route: ' + Response.StatusCode.ToString);
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;
}

procedure TfrmMapRouter.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.

