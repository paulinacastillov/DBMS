<!-- //
//
// This file is the add_faculty.jsp
//
//
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Faculty</title>
    <script>
        // JavaScript function to enable or disable the Excluded Department ID field
        function toggleExcludeDeptId() {
            const excludeDeptIdField = document.getElementById("excludeDeptId");
            const excludeDeptFlag = document.getElementById("exclude");

            // Enable the field only if the "Yes, exclude specific department" option is selected
            excludeDeptIdField.disabled = !excludeDeptFlag.checked;
        }
    </script>
</head>
<body>
    <h2>Add New Faculty Member</h2>
    
    <form action="add_faculty_process.jsp" method="post">
        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Field</th>
                <th>Input</th>
            </tr>
            <tr>
                <td><label for="fid">Faculty ID:</label></td>
                <td><input type="text" id="fid" name="fid" required></td>
            </tr>
            <tr>
                <td><label for="fname">Faculty Name:</label></td>
                <td><input type="text" id="fname" name="fname" required></td>
            </tr>
            <tr>
                <td><label for="deptid">Department ID:</label></td>
                <td><input type="text" id="deptid" name="deptid" required></td>
            </tr>
            <tr>
                <td colspan="2">
                    <p>Exclude a department from salary calculation?</p>
                    <input type="radio" id="include" name="excludeDeptFlag" value="0" checked onclick="toggleExcludeDeptId()">
                    <label for="include">No, use department highest value</label><br>

                    <input type="radio" id="exclude" name="excludeDeptFlag" value="1" onclick="toggleExcludeDeptId()">
                    <label for="exclude">Yes, exclude specific department</label>
                </td>
            </tr>
            <tr>
                <td><label for="excludeDeptId">Excluded Department ID (if excluding):</label></td>
                <td><input type="text" id="excludeDeptId" name="excludeDeptId" disabled></td>
            </tr>
        </table>

        <!-- Submit, Go Back, and Exit buttons -->
        <p>
            <input type="submit" value="Add Faculty">
            <input type="button" value="Ignore entry" onclick="window.location.href='get_all_faculty.jsp'">
            <input type="button" value="Exit application" onclick="window.location.href='goodbye.jsp'">
        </p>
    </form>
</body>
</html>
