object DMRest: TDMRest
  Height = 465
  Width = 617
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:9000/produto'
    Params = <>
    RaiseExceptionOn500 = False
    SynchronizedEvents = False
    Left = 160
    Top = 136
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id'
        Value = '1000'
      end>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 304
    Top = 48
  end
  object RESTResponse: TRESTResponse
    ContentType = 'text/html'
    Left = 304
    Top = 136
  end
  object RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter
    Dataset = FDMemTable
    FieldDefs = <>
    Left = 456
    Top = 128
  end
  object FDMemTable: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 256
    Top = 296
  end
end
