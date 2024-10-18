# Password Last Set Checker Script
# This script checks the last password set date for domain user accounts
# by querying the domain controller.

# Read usernames from the specified text file
$uN = Get-Content "C:\path\to\usernames.txt"
$r = @()  # Initialize an empty array to store results

foreach ($u in $uN) {
    Write-Host "Checking user: $u"
    
    # Run the net user command with /domain to retrieve user information from the domain controller
    $o = net user $u /domain 2>&1

    # Check if the output contains "User name" indicating the user exists
    if ($o -match "User name") {
        # Extract the "Password last set" line from the output
        $lastSetLine = $o | Select-String "Password last set"
        $r += "$u, $($lastSetLine.ToString())"  # Append the result to the array
    } else {
        Write-Host "User not found: $u"  # Inform if the user is not found
        $r += "$u, User not found"  # Record the user not found status
    }
}

# Save the results to a CSV file
$r | Out-File "C:\path\to\password_last_set_results.csv"
