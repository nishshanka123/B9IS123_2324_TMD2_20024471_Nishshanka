
function GetAllDevices() {
    let table = document.getElementById("tab1");
    let rows = table.getElementsByTagName('tr');

    fetch('/api/data')
        .then(response => response.json())
        .then(data => {
            console.log(data);
            data.Results.forEach(x => {
                let newRow = rows[0].cloneNode(true);
                let divs = newRow.getElementsByTagName('td');
                divs[0].innerHTML = x['ID'];
                divs[1].innerHTML = x['Name'];
                divs[2].innerHTML = x['Condition'];

                // Assign CSS classes to each column
                divs[0].classList.add('id-column');
                divs[1].classList.add('type-column');
                divs[2].classList.add('status-column');

                // Create and append edit and delete buttons to the row
                let editButton = document.createElement('button');
                editButton.textContent = 'Edit';
                editButton.addEventListener('click', () => editStudent(x['ID'], x['Type'], x['Status']));

                let deleteButton = document.createElement('button');
                deleteButton.textContent = 'Delete';
                deleteButton.addEventListener('click', () => deleteStudent(x['ID']));

                let actionCell = document.createElement('td');
                actionCell.classList.add('action-cell');
                actionCell.appendChild(editButton);
                actionCell.appendChild(deleteButton);

                newRow.appendChild(actionCell);

                table.appendChild(newRow);
            });
        });
}

  function DeleteRows() {
    let table=document.getElementById("tab1");
    let rowCount = table.rows.length;

    // Loop through all rows in reverse order and remove each row
    for (let i = rowCount - 1; i > 0; i--) {
        table.deleteRow(i);
    }
  }
  
  // Dummy edit and delete functions (replace with your logic)
  function editStudent(id, name, email) {
    openPopup(title='Edit Student Data', studentId=id, studentName=name, email=email);
  }
  
  function deleteStudent(id) {
    console.log(id);
    fetch(`/delete-student/${id}`, {
      method: 'DELETE',
    })
    .then(response => {
      if (!response.ok) {
        // Delete failed
        response.json().then(data => {
              showMessage(`Failed to delete student: ${data.error}`);
          });
      }
      else {
        // Delete successful
        showMessage('Student deleted successfully');
          // Refresh student data table
        refreshStudentTable();
      }
      
    })
    .catch(error => console.error('Error:', error));
}