object TimerEdit: TTimerEdit
  Left = 560
  Top = 299
  BorderStyle = bsDialog
  Caption = 'Edit Timer'
  ClientHeight = 153
  ClientWidth = 244
  Color = 15855006
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Visible = True
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object lblHour: TLabel
    Left = 24
    Top = 67
    Width = 50
    Height = 23
    Caption = 'Hours'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblMins: TLabel
    Left = 96
    Top = 67
    Width = 41
    Height = 23
    Caption = 'Mins'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSecs: TLabel
    Left = 168
    Top = 67
    Width = 42
    Height = 23
    Caption = 'Secs'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblChar1: TLabel
    Left = 77
    Top = 29
    Width = 8
    Height = 32
    Caption = ':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblChar2: TLabel
    Left = 151
    Top = 29
    Width = 8
    Height = 32
    Caption = ':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnDone: TSpeedButton
    Left = 63
    Top = 97
    Width = 99
    Height = 40
    Caption = 'Done'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = 12124170
    Font.Height = -16
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btnDoneClick
  end
  object seHours: TSpinEdit
    Left = 24
    Top = 32
    Width = 49
    Height = 29
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Value = 0
    OnChange = seHoursChange
  end
  object seMins: TSpinEdit
    Left = 88
    Top = 32
    Width = 57
    Height = 29
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Value = 0
    OnChange = seMinsChange
  end
  object seSecs: TSpinEdit
    Left = 162
    Top = 33
    Width = 57
    Height = 29
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Value = 0
    OnChange = seMinsChange
  end
end
