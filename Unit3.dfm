object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 796
  ClientWidth = 1177
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 280
    Top = 216
    Width = 9
    Height = 9
    Shape = stEllipse
    Visible = False
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 352
    Top = 224
  end
  object BonusTimer: TTimer
    Interval = 20000
    Left = 392
    Top = 224
  end
end
