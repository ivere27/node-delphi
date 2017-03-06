object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 310
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
    Height = 193
    Lines.Strings = (
      #39'use strict'#39
      ''
      'var num = 42;'
      'var foo = '#39'foo'#39';'
      ''
      'toby.on('#39'test'#39', function(x){'
      '  toby.hostCall('#39'echo'#39' , x);'
      '});'
      ''
      'var result = toby.hostCall('#39'dory'#39', {num, foo});'
      '// an error raised in non-console mode'
      '// console.log(`node :: toby.hostCall() = ${result}`);'
      ''
      'setInterval(function(){},1000); // dummy loop')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 238
    Width = 402
    Height = 64
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 207
    Width = 75
    Height = 25
    Caption = 'init node.js'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 207
    Width = 75
    Height = 25
    Caption = 'emit '#39'test'#39
    TabOrder = 3
    OnClick = Button2Click
  end
end
