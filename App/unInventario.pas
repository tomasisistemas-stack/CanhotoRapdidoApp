unit unInventario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Edit;

type
  TfrmInventario = class(TForm)
    ltop: TLayout;
    Rectangle1: TRectangle;
    lbMenu: TLabel;
    imgMenu: TImage;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    lbDescProduto: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    lbUnidade: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    lbQtdeEstoque: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    lbQtdReservada: TListBoxItem;
    Preço: TListBoxItem;
    lbPreco: TListBoxItem;
    Layout1: TLayout;
    Rectangle2: TRectangle;
    ImgVoltar: TImage;
    ImgSalvar: TImage;
    Layout2: TLayout;
    edAcerto: TEdit;
    RoundRect5: TRoundRect;
    lbMensagem: TLabel;
    procedure ImgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgSalvarClick(Sender: TObject);
  private
    procedure CarregarDadosProduto;
    procedure LimparCampos;
    procedure AcertoEstoque;
    { Private declarations }
  public
    { Public declarations }
    codebar, codigo : string;
  end;

var
  frmInventario: TfrmInventario;

implementation

{$R *.fmx}

uses
   unDMRest, Loading, unPrincipal;

procedure TfrmInventario.FormShow(Sender: TObject);
begin
  CarregarDadosProduto;
end;

procedure TfrmInventario.ImgSalvarClick(Sender: TObject);
begin
  lbMensagem.Visible := false;

  if trim(edAcerto.Text) = '' then
  begin
    lbMensagem.Visible := true;
    lbMensagem.Text := 'É necessário preencher o valor do acerto!';
    edacerto.setfocus;
    exit;
  end;

  AcertoEstoque;
end;

procedure TfrmInventario.ImgVoltarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmInventario.LimparCampos;
begin
  lbDescProduto.Text := '';
  lbQtdeEstoque.Text := '';
  lbQtdReservada.Text := '';
  lbUnidade.Text := '';
  lbPreco.Text := '';
end;


procedure TfrmInventario.CarregarDadosProduto;
var
  DM : TDMRest;
  sParams : TStringList;
begin
 // TLoading.show(frmInventario, 'Carregando...');
{  TThread.CreateAnonymousThread(procedure
  begin        }
    LimparCampos;
    DM := TDMRest.Create(nil);
    sParams := TStringList.Create;
    sParams.Add('codebar:'+codebar);
    dm.Execute('codigobarra', 'application/json', sParams);
    codigo := dm.FDMemTable.FieldByName('codProduto').AsString;
    lbDescProduto.Text := dm.FDMemTable.FieldByName('produto').AsString;
    lbQtdeEstoque.Text := dm.FDMemTable.FieldByName('qtdEstoque').AsString;
    lbQtdReservada.Text := dm.FDMemTable.FieldByName('qtdReservado').AsString;
    lbUnidade.Text := dm.FDMemTable.FieldByName('unidade').AsString;
    lbPreco.Text := formatfloat('R$ #,###,##0.00', dm.FDMemTable.FieldByName('precoVenda').AsFloat);

  {
    TThread.Synchronize(nil, procedure
    begin
      tLoading.Hide;
    end);

  end).start;   }
end;


end.
