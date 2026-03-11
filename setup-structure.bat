@echo off
REM Setup directory structure for Spark Email Plugin

echo Creating directory structure...

mkdir src\main\java\org\jivesoftware\spark\plugin\email 2>nul
mkdir src\main\resources 2>nul
mkdir target 2>nul

echo Moving Java source files...

move /Y EmailPlugin.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul
move /Y EmailPreference.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul
move /Y EmailMessageListener.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul
move /Y EnhancedEmailMessageListener.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul
move /Y EmailSender.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul
move /Y EmailStatusPanel.java src\main\java\org\jivesoftware\spark\plugin\email\ 2>nul

echo.
echo Directory structure created successfully!
echo.
echo Project structure:
echo   src/main/java/org/jivesoftware/spark/plugin/email/
echo     - EmailPlugin.java
echo     - EmailPreference.java
echo     - EmailMessageListener.java
echo     - EnhancedEmailMessageListener.java
echo     - EmailSender.java
echo     - EmailStatusPanel.java
echo   pom.xml
echo   plugin.xml
echo.
echo You can now run: build.bat
echo.

pause
