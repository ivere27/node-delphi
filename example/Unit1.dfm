object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 281
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 402
    Height = 169
    Lines.Strings = (
      #39'use strict'#39
      ''
      'var num = 42;'
      'var foo = '#39'foo'#39';'
      ''
      'toby.on('#39'test'#39', function(x){'
      '  console.log(`node :: toby.on(test) = ${x}`);'
      '});'
      ''
      'var result = toby.hostCall('#39'dory'#39', {num, foo});'
      'console.log(`node :: toby.hostCall() = ${result}`);')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 208
    Width = 402
    Height = 64
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 177
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
