# ImprovedConvertFromJson

[![Build status](https://ci.appveyor.com/api/projects/status/jjgrvbutb07tjdhe?svg=true)](https://ci.appveyor.com/project/LiamLeane/improvedconvertfromjson)

This Powershell module provides a single function, ConvertFrom-JsonWithArgs, which imitates the behavior of ConvertFrom-Json but allows for the MaxJsonLength to be overridden.

The function will produce precisely the same type tree as ConvertFrom-Json so can be used with ConvertTo-Json without changing structure as well as simply exchanged with ConvertFrom-Json when you encounter the default limit. MaxJsonLength defaults to Int.MaxValue.

```powershell
ConvertTo-JsonWithArgs -InputObject '{"key": {"key": "value"}}' -MaxJsonLength 200
```

```powershell
ConvertTo-JsonWithArgs '{"key": {"key": "value"}}' 200
```

```powershell
'{"key": {"key": "value"}}' | ConvertTo-JsonWithArgs -MaxJsonLength 200
```