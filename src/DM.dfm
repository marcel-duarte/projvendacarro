object DataModule2: TDataModule2
  Height = 253
  Width = 317
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Marcel\Projetos\SantiniDocesSalgados\Api\Comum\dlls\libpq.dll'
    Left = 90
    Top = 126
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=meuevento'
      'User_Name=postgres'
      'Password=123456'
      'Server=localhost'
      'DriverID=PG')
    LoginPrompt = False
    Left = 92
    Top = 34
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 208
    Top = 72
  end
end
