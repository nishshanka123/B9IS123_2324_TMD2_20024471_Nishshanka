
let sortColumn = 0;
let sortDirection = 'asc';
let headers;

function GetAllHomeDevices() {
    //clearTable()
    addEmployeeDetails()
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
    th7.textContent ='Device User';
    tableHeaderRow.appendChild(th7);

    const th8 = document.createElement("th");
    th8.textContent ='Manufacture Date';
    tableHeaderRow.appendChild(th8);

    const th9 = document.createElement("th");
    th9.textContent ='Model Number';
    tableHeaderRow.appendChild(th9);

    const th10 = document.createElement("th");
    th10.textContent ='Actions';
    tableHeaderRow.appendChild(th10);

    table.appendChild(tableHeaderRow)

    // Get the table headers
    headers = document.querySelectorAll('#myTable th');

    // Add event listeners to the table headers
    headers.forEach((header, index) => {
        header.addEventListener('click', () => sortTable(index));
    });

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
              cell7.textContent = x['DeviceUser'];
              row.appendChild(cell7);

              const cell8 = document.createElement("td");
              cell8.textContent = x['ManufacturedDate'];
              row.appendChild(cell8);

              const cell9 = document.createElement("td");
              cell9.textContent = x['ModelNumber'];
              row.appendChild(cell9);

                // Create and append edit and delete buttons to the row
                const cell10 = document.createElement("td");
                let editButton = document.createElement('button');
                editButton.textContent = 'Edit';
                editButton.addEventListener('click', () => editDevice(x));

                let deleteButton = document.createElement('button');
                deleteButton.textContent = 'Delete';
                deleteButton.addEventListener('click', () => deleteConfirmation(x['AssertNo'], x['DeviceSerial']));
                cell10.appendChild(editButton);
                cell10.appendChild(deleteButton);

                row.appendChild(cell10);

                table.appendChild(row);
            });
            
        });
}

//Dynamicaly populate employee names
function addEmployeeDetails() {
  employee_select = document.getElementById('employee_name');
  employee_select.options.length = 0;
 
  fetch(`/api/getEmployeeDetails`)
    .then(response => response.json())
    .then(data => {
      console.log(data);
      data.Results.forEach(employee_data => {
            option = document.createElement('option');
            option.value = employee_data['ID'];
            option.text = employee_data['Name'];
            employee_select.add(option);
          });
      })
      .catch(error => {
          console.error('Error:', error);
      });
  
}

function sortTable(column) {
    if (column === sortColumn) {
        // Toggle the sort direction
        sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
        // Update the sort column and direction
        sortColumn = column;
        sortDirection = 'asc';
    }

    // Get the table rows
    const table = document.getElementById('myTable');
    const rows = Array.from(table.getElementsByTagName('tr')).slice(1); // Skip the header row

    // Sort the rows
    rows.sort((a, b) => {
        const aValue = a.getElementsByTagName('td')[column].textContent.toLowerCase();
        const bValue = b.getElementsByTagName('td')[column].textContent.toLowerCase();

        if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
        if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
        return 0;
    });

    // Update the table rows
    rows.forEach(row => table.appendChild(row));

    // Update the sorting icons
    headers.forEach((header, index) => {
        header.querySelector('i').className = index === sortColumn
            ? `fa fa-sort-${sortDirection}`
            : 'fa fa-sort';
    });
}

  function myFunctionSearch() {
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("myInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("myTable");
    tr = table.getElementsByTagName("tr");
  
    for (i = 1; i < tr.length; i++) { // Start from the second row (index 1) to skip the header row
      var foundMatch = false;
  
      for (var j = 0; j < tr[i].cells.length; j++) { // Loop through each cell in the row
        td = tr[i].cells[j];
        if (td) {
          txtValue = td.textContent || td.innerText;
          if (txtValue.toUpperCase().indexOf(filter) > -1) {
            foundMatch = true;
            break; // Exit the inner loop if a match is found
          }
        }
      }
  
      if (foundMatch) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
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

  //Edit device from system
  function editDevice(data) {
    changeFormContent('update_device',data)

  }

    //Add device to system
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
      var assert_no = data['AssertNo'];
      var serial_no = data['DeviceSerial'];
      formTitle.textContent = 'Edit Device Details';
      submitButton.textContent = 'Update Device';
      deviceForm.action = `/api/update_device/${assert_no}/${serial_no}`; // Update form action

      populateForm(data); // Populate form fields with data
    }
}

// Function to populate form fields with data
function populateForm(data) {
    document.getElementById('assert_no').value = data['AssertNo'];
    document.getElementById('assert_no').disabled = true;
    document.getElementById('device_name').value = data['DeviceName'];
    document.getElementById('device_condition').value = data['DeviceCondition'];
    document.getElementById('device_type').value = data['DeviceType'];
    document.getElementById('device_serial').value = data['DeviceSerial'];
    document.getElementById('device_serial').disabled = true;
    document.getElementById('device_firmware').value = data['DeviceFirmware'];
    document.getElementById('device_MD').value = data['ManufacturedDate'];
    document.getElementById('device_MD').max = getCurrentDate(); // Set the max attribute to the current date
    document.getElementById('model_no').value = data['ModelNumber'];
}
function getCurrentDate() {
  const today = new Date();
  const year = today.getFullYear();
  const month = String(today.getMonth() + 1).padStart(2, '0');
  const day = String(today.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
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
    document.getElementById('assert_no').disabled = false;
    document.getElementById('device_serial').disabled = false;
}
function getDeviceNamesByCategory(category) {
  // Clear the existing options in the device_name dropdown
  var deviceNameDropdown = document.getElementById('device_name');
  deviceNameDropdown.options.length = 0;

  // Add the 'All' option
  var allOption = document.createElement('option');
  allOption.value = 'all';
  allOption.text = 'All';
  deviceNameDropdown.add(allOption);

  // Make an AJAX request to the server-side to fetch device names based on the selected category
  fetch(`/api/get_device_names?category=${category}`)
      .then(response => response.json())
      .then(data => {
          data.forEach(device_name => {
              var option = document.createElement('option');
              option.value = device_name;
              option.text = device_name;
              deviceNameDropdown.add(option);
          });
      })
      .catch(error => {
          console.error('Error:', error);
      });
}

// Function to handle form submission
document.addEventListener('DOMContentLoaded', function() {

  GetAllHomeDevices();

  // Place your JavaScript code here
  document.getElementById('deviceForm').addEventListener('submit', function(event) {
      event.preventDefault(); // Prevent default form submission

      var formData = new FormData(this); // Get form data
    var manufacturedDate = formData.get('device_MD');
    var currentDate = new Date().toISOString().slice(0, 10); // Get the current date in YYYY-MM-DD format

    if (manufacturedDate > currentDate) {
      showMessage('Manufactured Date must be less than or equal to the current date.');
      //clearForm()
      return;
    }

        var api = document.getElementById('deviceForm').action
        console.log(api)
        let btnText = document.getElementById("submitButton").innerHTML;
        console.log(btnText)

        if (btnText == 'Add Device') {
          if (!assertIdSearch()) {
            console.log("Nilusha Niwanthaka - Add device")
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
        } else {
          console.log("Nilusha Niwanthaka - update device")
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