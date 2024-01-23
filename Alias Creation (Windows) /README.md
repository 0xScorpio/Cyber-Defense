# Create a batch file that points to the aliased location:
```
@echo off
C:\folder1\app.exe %*
```
*The %* allows for passing arguments to the executable

# Pass the batch file into the PATH environment variable:
```
setx PATH "%PATH%;C:\folder1\batch.bat" /M
```

# You can now access the executable through your alias, with arguments if need be.
```
alias arg1 arg2 arg3 ...
```
