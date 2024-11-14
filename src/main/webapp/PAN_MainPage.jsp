<!DOCTYPE html>
<html>
<head>
    <title>PAN Database System</title>
    <link href="assets/css/style.css" rel="stylesheet"/>
</head>
<body>
    <h1>WELCOME TO THE PATIENT ASSISTANT NETWORK DATABASE SYSTEM</h1>
    <table border="1">
        <tr>
            <th>Query</th>
            <th>Description</th>
        </tr>
        <tr>
            <td>1</td>
            <td>Enter a new team into the database</td>
            <td><form action='PAN_query1.jsp' method='get'><input type='submit' name='query1' value='Execute Query 1'></form></td> 
        </tr>
        <tr>
            <td>2</td>
            <td>Enter a new client into the database and associate him or her with one or more teams</td>
            <td><form action='PAN_query2.jsp' method='post'><input type='submit' name='query2' value='Execute Query 2'></form></td>
        </tr>
        <tr>
            <td>3</td>
            <td>Enter a new volunteer into the database and associate him or her with one or more teams</td>
            <td><form action='PAN_query3.jsp' method='post'><input type='submit' name='query3' value='Execute Query 3'></form></td>
        </tr>
        <tr>
            <td>4</td>
            <td>Enter the number of hours a volunteer worked this month for a particular team</td>
            <td><form action='PAN_query4.jsp' method='post'><input type='submit' name='query4' value='Execute Query 4'></form></td>
        </tr>
        <tr>
            <td>5</td>
            <td>Enter a new employee into the database and associate him or her with one or more teams</td>
            <td><form action='PAN_query5.jsp' method='post'><input type='submit' name='query5' value='Execute Query 5'></form></td>
        </tr>
        <tr>
            <td>6</td>
            <td>Enter an expense charged by an employee</td>
            <td><form action='PAN_query6.jsp' method='post'><input type='submit' name='query6' value='Execute Query 6'></form></td>
        </tr>
        <tr>
            <td>7</td>
            <td>Enter a new donor and associate him or her with several donations</td>
            <td><form action='PAN_query7.jsp' method='post'><input type='submit' name='query7' value='Execute Query 7'></form></td>
        </tr>
        <tr>
            <td>8</td>
            <td>Retrieve the name and phone number of the doctor of a particular client</td>
            <td><form action='PAN_query8.jsp' method='post'><input type='submit' name='query8' value='Execute Query 8'></form></td>
        </tr>
        <tr>
            <td>9</td>
            <td>Retrieve the total amount of expenses charged by each employee for a particular period of time</td>
            <td><form action='PAN_query9.jsp' method='post'><input type='submit' name='query9' value='Execute Query 9'></form></td>
        </tr>
        <tr>
            <td>10</td>
            <td>Retrieve the list of volunteers that are members of teams that support a particular client</td>
            <td><form action='PAN_query10.jsp' method='post'><input type='submit' name='query10' value='Execute Query 10'></form></td>
        </tr>
        <tr>
            <td>11</td>
            <td>Retrieve the names of all teams that were founded after a particular date</td>
            <td><form action='PAN_query11.jsp' method='post'><input type='submit' name='query11' value='Execute Query 11'></form></td>
        </tr>
        <tr>
            <td>12</td>
            <td>Retrieve the names, social security numbers, contact information, and emergency contact information of all people</td>
            <td><form action='PAN_query12.jsp' method='post'><input type='submit' name='query12' value='Execute Query 12'></form></td>
        </tr>
        <tr>
            <td>13</td>
            <td>Retrieve the name and total amount donated by donors that are also employees</td>
            <td><form action='PAN_query13.jsp' method='post'><input type='submit' name='query13' value='Execute Query 13'></form></td>
        </tr>
        <tr>
            <td>14</td>
            <td>Increase the salary by 10% of all employees to whom more than one team must report</td>
            <td><form action='PAN_query14.jsp' method='post'><input type='submit' name='query14' value='Execute Query 14'></form></td>
        </tr>
        <tr>
            <td>15</td>
            <td>Delete all clients who do not have health insurance and whose value of importance for transportation is less than 5</td>
            <td><form action='PAN_query15.jsp' method='post'><input type='submit' name='query15' value='Execute Query 15'></form></td>
        </tr>
        <tr>
            <td>16</td>
            <td>Import: enter new teams from a data file</td>
            <td><form action='PAN_query16.jsp' method='post'><input type='submit' value='Import teams file'></form></td>
        </tr>
        <tr>
            <td>17</td>
            <td>Export: Retrieve names and mailing addresses of all people on the mailing list</td>
            <td><form action='PAN_query17.jsp' method='post'><input type='submit' value='Export mail list'></form></td>
        </tr>
    </table>

    <p>
        <input type="button" value="Exit application" onclick="window.location.href='goodbye.jsp'">
    </p>
</body>
</html>
