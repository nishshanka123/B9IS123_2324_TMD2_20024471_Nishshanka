
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
                divs[3].innerHTML = x['Serial'];
                divs[4].innerHTML = x['Date'];
                divs[5].innerHTML = x['Type'];

                // Assign CSS classes to each column
                // divs[0].classList.add('id-column');
                // divs[1].classList.add('type-column');
                // divs[2].classList.add('status-column');

                // Create and append edit and delete buttons to the row
                let editButton = document.createElement('button');
                editButton.textContent = 'Edit';
                editButton.addEventListener('click', () => editDeice(x));

                let deleteButton = document.createElement('button');
                deleteButton.textContent = 'Delete';
                deleteButton.addEventListener('click', () => deleteDevice(x['ID']));

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

  function editDeice(data) {
    changeFormContent('edit',data)
  }
  
 
  
  function deleteDevice(id) {
    console.log(id);
    fetch(`/delete_device/${id}`, {
      method: 'DELETE',
    })
    .then(response => {
      if (!response.ok) {
        // Delete failed
        response.json().then(data => {
              showMessage(`Failed to delete device: ${data.error}`);
          });
      }
      else {
        // Delete successful
        showMessage('Device deleted successfully');
          // Refresh student data table
        refreshStudentTable();
      }
      
    })
    .catch(error => console.error('Error:', error));
}

// Function to show popup message
function showMessage(message) {
    let popup = document.getElementById('popupMessage');
    let messageText = document.getElementById('messageText');
    messageText.innerText = message;
    popup.style.display = 'block';
    // Hide popup after 3 seconds
    setTimeout(() => {
        popup.style.display = 'none';
    }, 3000);
}

function changeFormContent(selection, data) {
    var formTitle = document.getElementById('formTitle');
    var submitButton = document.getElementById('submitButton');
    var deviceForm = document.getElementById('deviceForm');

    if (selection === 'add') {
        formTitle.textContent = 'Add New Device';
        submitButton.textContent = 'Add Device';
        deviceForm.action = '/add'; // Update form action
        clearForm(); // Clear form fields
    } else if (selection === 'edit') {
        formTitle.textContent = 'Edit Device';
        submitButton.textContent = 'Update Device';
        deviceForm.action = '/update'; // Update form action
        populateForm(data); // Populate form fields with data
    }
}

// Function to populate form fields with data
function populateForm(data) {
    document.getElementById('device_name').value = data['Name'];
    document.getElementById('device_condition').value = data['Condition'];
    document.getElementById('device_serial').value = data['Serial'];
    document.getElementById('device_MD').value = data['Date'];
    document.getElementById('device_type').value = data['Type'];
}

// Function to clear form fields
function clearForm() {
    document.getElementById('device_name').value = '';
    document.getElementById('device_condition').value = 'new';
    document.getElementById('device_serial').value = '';
    document.getElementById('device_MD').value = '';
    document.getElementById('device_type').value = 'phone';
}