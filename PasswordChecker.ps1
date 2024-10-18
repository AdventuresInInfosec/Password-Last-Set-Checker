# Define the path to the input file containing usernames
$uF = "C:\path\to\your\usernames.txt"  # Update this path accordingly
# Initialize an empty array to store results
$r = @()

# Check if the input file exists
if (Test-Path $uF) {
    # Read the content of the usernames file
    $uN = Get-Content $uF

    # Loop through each username in the file
    foreach ($u in $uN) {
        # Execute the net user command to get user info
        $o = net user $u 2>&1
        
        # Check if the output contains "User name" indicating the user exists
        if ($o -match "User name") {
            # Loop through the output lines to find the password last set date
            foreach ($l in $o) {
                if ($l -match "Password last set") {
                    # Add the username and last password set date to results
                    $r += "$u, $l"
                }
            }
        } else {
            # If user is not found, add an appropriate message to results
            $r += "$u, User not found"
        }
    }

    # Save the results to a CSV file
    $r | Out-File "C:\path\to\your\password_last_set_results.csv"  # Update this path accordingly
    Write-Host "Results saved to password_last_set_results.csv"
} else {
    # Inform if the usernames file was not found
    Write-Host "Usernames file not found."
}
