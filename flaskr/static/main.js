
  function GetAllHomeDevices() {
    //clearTable()
    console.log("Inside get all")
    const table = document.getElementById('myTable');
    table.innerHTML = '';
    const tableHeaderRow = document.createElement("tr");

    const th1 = document.createElement("th");
    th1.textContent ="Assert Number";
    tableHeaderRow.appendChild(th1);

    const th2 = document.createElement("th");
    th2.textContent ="Device Name";
    tableHeaderRow.appendChild(th2);

    const th3 = document.createElement("th");
    th3.textContent ='Device Condition';
    tableHeaderRow.appendChild(th3);

    const th4 = document.createElement("th");
    th4.textContent ='Device Type';
    tableHeaderRow.appendChild(th4);

    const th5 = document.createElement("th");
    th5.textContent ='Serial No';
    tableHeaderRow.appendChild(th5);

    const th6 = document.createElement("th");
    th6.textContent ='Device Firmware';
    tableHeaderRow.appendChild(th6);

    const th7 = document.createElement("th");
    th7.textContent ='Manufacture Date';
    tableHeaderRow.appendChild(th7);

    const th8 = document.createElement("th");
    th8.textContent ='Model Number';
    tableHeaderRow.appendChild(th8);

    const th9 = document.createElement("th");
    th9.textContent ='Actions';
    tableHeaderRow.appendChild(th9);

    table.appendChild(tableHeaderRow)



    // let table = document.getElementById("myTable");
    // let rows = table.getElementsByTagName('tr');
    const tableBody = document.getElementById("tableBody");

    fetch('/api/get_devices')
        .then(response => response.json())
        .then(data => {
            console.log(data);
            data.Results.forEach(x => {

              const row = document.createElement("tr");

              const cell1 = document.createElement("td");
              cell1.textContent = x['AssertNo'];
              row.appendChild(cell1);

              const cell2 = document.createElement("td");
              cell2.textContent = x['DeviceName'];
              row.appendChild(cell2);

              const cell3 = document.createElement("td");
              cell3.textContent = x['DeviceCondition'];
              row.appendChild(cell3);

              const cell4 = document.createElement("td");
              cell4.textContent = x['DeviceType'];
              row.appendChild(cell4);

              const cell5 = document.createElement("td");
              cell5.textContent = x['DeviceSerial'];
              row.appendChild(cell5);

              const cell6 = document.createElement("td");
              cell6.textContent = x['DeviceFirmware'];
              row.appendChild(cell6);

              const cell7 = document.createElement("td");
              cell7.textContent = x['ManufacturedDate'];
              row.appendChild(cell7);

              const cell8 = document.createElement("td");
              cell8.textContent = x['ModelNumber'];
              row.appendChild(cell8);

                // Create and append edit and delete buttons to the row
                const cell9 = document.createElement("td");
                let editButton = document.createElement('button');
                editButton.textContent = 'Edit';
                editButton.addEventListener('click', () => editDevice(x));

                let deleteButton = document.createElement('button');
                deleteButton.textContent = 'Delete';
                deleteButton.addEventListener('click', () => deleteConfirmation(x['AssertNo'], x['DeviceSerial']));
                cell9.appendChild(editButton);
                cell9.appendChild(deleteButton);

                row.appendChild(cell9);

                table.appendChild(row);
            });
            
        });
  }

  // function SearchDevices() {
  //   clearTable();
  //   let table = document.getElementById("myTable");
  //   let rows = table.getElementsByTagName('tr');
  //   let search_value = document.getElementById("search_input").value.trim();

  //   if (search_value) {
  //     console.log(search_value);
  //       fetch(`/api/search/${search_value}`)
  //       .then(response => response.json())
  //       .then(data => {
  //           console.log(data);
  //           data.Results.forEach(x => {
  //               let newRow = rows[0].cloneNode(true);
  //               let divs = newRow.getElementsByTagName('td');
  //               divs[0].innerHTML = x['AssertNo'];
  //               divs[1].innerHTML = x['DeviceName'];
  //               divs[2].innerHTML = x['DeviceCondition'];
  //               divs[3].innerHTML = x['DeviceType'];
  //               divs[4].innerHTML = x['DeviceSerial'];
  //               divs[5].innerHTML = x['DeviceFirmware'];
  //               divs[6].innerHTML = x['ManufacturedDate'];
  //               divs[7].innerHTML = x['ModelNumber'];

  //               // Assign CSS classes to each column
  //               // divs[0].classList.add('id-column');
  //               // divs[1].classList.add('type-column');
  //               // divs[2].classList.add('status-column');

  //               // Create and append edit and delete buttons to the row
  //               let editButton = document.createElement('button');
  //               editButton.textContent = 'Edit';
  //               editButton.addEventListener('click', () => editDevice(x));

  //               let deleteButton = document.createElement('button');
  //               deleteButton.textContent = 'Delete';
  //               deleteButton.addEventListener('click', () => deleteDevice(x['AssertNo'], x['DeviceSerial']));

  //               let actionCell = document.createElement('td');
  //               actionCell.classList.add('action-cell');
  //               actionCell.appendChild(editButton);
  //               actionCell.appendChild(deleteButton);

  //               newRow.appendChild(actionCell);

  //               table.appendChild(newRow);
  //           });
  //       });
  //   }
  // }

  function myFunctionSearch() {
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("myInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("myTable");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[0];
      if (td) {
        txtValue = td.textContent || td.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
        } else {
          tr[i].style.display = "none";
        }
      }       
    }
  }

  function assertIdSearch() {
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("assert_no");
    filter = input.value.toUpperCase();
    table = document.getElementById("myTable");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[0];
      if (td) {
        txtValue = td.textContent || td.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          showMessage("Assert number already exist !! . Please user another assert number.")
          return true
        } else {
          return false
        }
      }       
    }
  }


  function editDevice(data) {
    changeFormContent('update_device',data)

  }

  function addDevice() {
    changeFormContent('add_device')

  }
  
  function deleteConfirmation(assert_no, serial_no) {
    var txt;
    if (confirm("Are you sure you want to delete the device")) {
      deleteDevice(assert_no, serial_no)
    } else {
      txt = "You pressed Cancel!";
    }
  }
  
  function deleteDevice(assert_no, serial_no) {
    console.log(assert_no);
    fetch(`/api/delete_device/${assert_no}/${serial_no}`, {
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
        clearTable()
        GetAllHomeDevices()
      }
      
    })
    .catch(error => console.error('Error:', error));
}

function clearTable() {
  let table = document.getElementById("myTable");
  // Remove all rows except the header row
  while (table.rows.length > 1) {
    table.deleteRow(1);
  }
  
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
  console.log(selection);
    var formTitle = document.getElementById('formTitle');
    var submitButton = document.getElementById('submitButton');
    var deviceForm = document.getElementById('deviceForm');

    if (selection == 'add_device') {
      formTitle.textContent = 'Add New Device';
      submitButton.textContent = 'Add Device';
      deviceForm.action = '/api/add_device'; // Update form action

      clearForm(); // Clear form fields
    } else if (selection == 'update_device') {
      formTitle.textContent = 'Edit Device Details';
      submitButton.textContent = 'Update Device';
      deviceForm.action = '/api/update_device'; // Update form action

      populateForm(data); // Populate form fields with data
    }
}

// Function to populate form fields with data
function populateForm(data) {
    document.getElementById('assert_no').value = data['AssertNo'];
    // document.getElementById('assert_no').disabled = true;
    document.getElementById('device_name').value = data['DeviceName'];
    document.getElementById('device_condition').value = data['DeviceCondition'];
    document.getElementById('device_type').value = data['DeviceType'];
    document.getElementById('device_serial').value = data['DeviceSerial'];
    // document.getElementById('device_serial').disabled = true;
    document.getElementById('device_firmware').value = data['DeviceFirmware'];
    document.getElementById('device_MD').value = data['ManufacturedDate'];
    document.getElementById('model_no').value = data['ModelNumber'];
}

// Function to clear form fields
function clearForm() {
    document.getElementById('assert_no').value = '';
    document.getElementById('device_name').value = '';
    document.getElementById('device_condition').value = 'new';
    document.getElementById('device_type').value = 'Manufactured';
    document.getElementById('device_serial').value = '';
    document.getElementById('device_firmware').value = '';
    document.getElementById('device_MD').value = '';
    document.getElementById('model_no').value = '';
}

// Function to handle form submission
document.addEventListener('DOMContentLoaded', function() {

  GetAllHomeDevices();

  // Place your JavaScript code here
  document.getElementById('deviceForm').addEventListener('submit', function(event) {
      event.preventDefault(); // Prevent default form submission

      if (!assertIdSearch()) {
        var formData = new FormData(this); // Get form data

        var api = document.getElementById('deviceForm').action
        console.log(api)
        // Send form data to the API endpoint
        fetch(api, {
            method: 'POST',
            body: formData
        })
        .then(response => response.json()) // Parse response JSON
        .then(data => {
            // Display message to the user
            showMessage(data.message);
            clearTable()
            GetAllHomeDevices()
        })
        .catch(error => {
            console.error('Error:', error);
        });
      }
      
  });

  // Get the input element
  const assertNo = document.getElementById('assert_no');
  const serialNo = document.getElementById('device_serial');

  // Add event listener for input event
  assertNo.addEventListener('input', function(event) {
      // Get the input value
      let value = event.target.value;

      // Remove any non-numeric characters using regular expression
      value = value.replace(/\D/g, '');

      // Update the input value
      event.target.value = value;
  });

  // Add event listener for input event
  serialNo.addEventListener('input', function(event) {
    // Get the input value
    let value = event.target.value;

    // Remove any non-numeric characters using regular expression
    value = value.replace(/\D/g, '');

    // Update the input value
    event.target.value = value;
  });
});