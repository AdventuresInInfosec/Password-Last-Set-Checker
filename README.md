# Password Last Set Checker Tool 🔍
A PowerShell tool for auditing user password last set dates.


Overview
Welcome, fellow security analysts! This project aims to help you efficiently check when passwords were last set for users identified in incident reports, threat hunts, or IDR reports. Let’s get started!

Step 1: Prepare Your Email List 📧
Obtain Your Email List:

Extract the email addresses provided in your incident/threat hunt reports and save them in a spreadsheet (Excel is perfect for this!).
Isolate Usernames (assuming complete email addresses are provided in column A):

In Excel, use the following formula to extract the username (everything before the @):
excel
Copy code
=LEFT(A1, FIND("@", A1) - 1)
Drag this formula down to apply it to all relevant email addresses.
Save as TXT:

Copy the extracted usernames and paste them into a new Notepad file.
Save the file as usernames.txt in an easily accessible location.
Step 2: PowerShell Script Implementation ⚙️
Open PowerShell:

Search for PowerShell in your Start menu and launch it.
Prepare the Script:

Copy and paste the following script, which checks the last password set date for each user:
powershell
Copy code
$usernamesFile = "C:\path\to\your\usernames.txt"  # Update this path!
$results = @()

if (Test-Path $usernamesFile) {
    $usernames = Get-Content $usernamesFile

    foreach ($username in $usernames) {
        $output = net user $username 2>&1
        if ($output -match "User name") {
            foreach ($line in $output) {
                if ($line -match "Password last set") {
                    $results += "$username, $line"
                }
            }
        } else {
            $results += "$username, User not found"
        }
    }

    $results | Out-File "C:\path\to\your\password_last_set_results.csv"  # Update this path!
    Write-Host "Results saved to password_last_set_results.csv"
} else {
    Write-Host "Usernames file not found."
}
Important: Be sure to update the file paths for both your usernames.txt and the desired output location for the results.
Execute the Script:

If script fails or the CSV is blank, you may need to run the domain users script (in this repo).

Hit Enter to run the script and watch as it processes the usernames!
Step 3: Review the Results 📊
Open the password_last_set_results.csv file you generated.
It will display usernames along with the date their passwords were last set. If any usernames weren’t found, those will be noted as well.
Step 4: Upload to GitHub 🚀
Create a New Repository:

Go to GitHub and set up a new repository for this tool.
Add Your Files:

Upload the usernames.txt, the PowerShell script, and any relevant documentation.
Document the Process:

Include these instructions in your README file for easy reference.
Security Note 🔒
Always ensure that any sensitive information is handled securely. Avoid exposing usernames and password-related information in public repositories.
