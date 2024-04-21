/**
 * JS file for displaying and handling report response.
 */
document.addEventListener('DOMContentLoaded', function() {
    //console.log('Hello World--------------------TEST');
    const form = document.getElementById('report-form');

    if(form != null)
    {
        form.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent default form submission behavior

            // Serialize form data
            const formData = new FormData(form);
            const data = {};
            formData.forEach((value, key) => {
                data[key] = value;
            });
            console.log(data);
            // Make a POST request to the server
            fetch('/generateReports', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                // Handle response data (if needed)
                console.log("response----: ")
                console.log("Data--------: ", data);
                //var jdata = JSON.parse(data);
                var count = data["count"];

                if(count > 0)
                {
                    // Update the DOM with the response data (e.g., populate a table)
                    const searchBox = document.getElementById('report-search'); // Get the search box
                    console.log("Search box: ", searchBox);
                    searchBox.innerHTML = '<span class="label search">Filter Report: </span> <input type="text" id="assetNo" onkeyup="searchByAssetNo()" class="search-data" placeholder="Search by Asset No.."></input>';
                    //searchBox.innerHTML = 'xxxxx';
                    // Get the empty table element created for the report
                    const table = document.getElementById('report-table'); // Get the table element
                    // Clear existing table rows if any
                    //console.log(table); // debug purpose
                    table.innerHTML = '';

                    // Create table header row
                    const headerRow = document.createElement('tr');
                    // Table header
                    const th1 = document.createElement('th');
                    th1.textContent = "Serial No";
                    headerRow.appendChild(th1);
                    const th2 = document.createElement('th');
                    th2.textContent = "Asset No";
                    headerRow.appendChild(th2);
                    const th3 = document.createElement('th');
                    th3.textContent = "Firmware or OS";
                    headerRow.appendChild(th3);
                    const th = document.createElement('th');
                    th.textContent = "Manufacturer or Model";
                    headerRow.appendChild(th);
                    const th4 = document.createElement('th');
                    th4.textContent = "Produced date";
                    headerRow.appendChild(th4);
                    const th5 = document.createElement('th');
                    th5.textContent = "Name";
                    headerRow.appendChild(th5);
                    const th6 = document.createElement('th');
                    th6.textContent = "Condition";
                    headerRow.appendChild(th6);
                    const th7 = document.createElement('th');
                    th7.textContent = "Type";
                    headerRow.appendChild(th7);
                    const th8 = document.createElement('th');
                    //th8.textContent = "Description";
                    //headerRow.appendChild(th8);
                    const th9 = document.createElement('th');
                    th9.textContent = "Owner";
                    headerRow.appendChild(th9);
                    const th10 = document.createElement('th');
                    th10.textContent = "Project";
                    headerRow.appendChild(th10);


                    /*"Serial No" : record_data[0] if len(record_data) > 0 else None,
                            "Asset No" : record_data[1] if len(record_data) > 1 else None,
                            "Firmware or OS" : record_data[2] if len(record_data) > 2 else None,
                            "Manufacturer or Model" : record_data[3] if len(record_data) > 3 else None,
                            "Manufactured-purchased date" : record_data[4] if len(record_data) > 4 else None,
                            "Name" : record_data[5] if len(record_data) > 5 else None,
                            "Condition" : record_data[6] if len(record_data) > 6 else None,
                            "Type" : record_data[7] if len(record_data) > 7 else None,
                            "Description" : record_data[8] if len(record_data) > 8 else "NA"*/
                    /*
                    // following block generated in assending order
                    for (const key in data.JsonData[0]) {
                        console.log("TH : ", key);
                        const th = document.createElement('th');
                        th.textContent = key;
                        headerRow.appendChild(th);
                    }*/
                    table.appendChild(headerRow);

                    // Create table rows for each data record
                    data.JsonData.forEach(record => {
                        const row = document.createElement('tr');
                        const cell1 = document.createElement('td');
                        cell1.textContent = record["Serial No"];
                        row.appendChild(cell1);
                        const cell = document.createElement('td');
                        cell.textContent = record["Asset No"];
                        row.appendChild(cell);
                        const cell2 = document.createElement('td');
                        cell2.textContent = record["Firmware or OS"];
                        row.appendChild(cell2);
                        const cell3 = document.createElement('td');
                        cell3.textContent = record["Manufacturer or Model"];
                        row.appendChild(cell3);
                        const cell4 = document.createElement('td');
                        cell4.textContent = record["Manufactured-purchased date"];
                        row.appendChild(cell4);
                        const cell5 = document.createElement('td');
                        cell5.textContent = record["Name"];
                        row.appendChild(cell5);
                        const cell6 = document.createElement('td');
                        cell6.textContent = record["Condition"];
                        row.appendChild(cell6);
                        const cell7 = document.createElement('td');
                        cell7.textContent = record["Type"];
                        row.appendChild(cell7);
                        const cell8 = document.createElement('td');
                        //cell8.textContent = record["Description"];
                        //row.appendChild(cell8);
                        const cell9 = document.createElement('td');
                        cell9.textContent = record["Owner"];
                        row.appendChild(cell9);
                        const cell10 = document.createElement('td');
                        cell10.textContent = record["Project"];
                        row.appendChild(cell10);
                        /*
                        // following block is generated in assending order
                        for (const key in record) {
                            const cell = document.createElement('td');
                            cell.textContent = record[key];
                            row.appendChild(cell);
                        }*/
                        table.appendChild(row);
                    });
                }
                else
                {
                    // Update the DOM with the response data
                    const searchBox = document.getElementById('report-search'); // Get the search box
                    console.log("Search box: ", searchBox);
                    searchBox.innerHTML = '<p>No records found</p>';

                    const table = document.getElementById('report-table'); // Get the table element
                    // Clear existing table rows if any
                    //console.log(table); // debug purpose
                    table.innerHTML = '';
                }
            })
            .catch(error => {
                console.error('Error Occurred:', error);
            });
        });
    } else
    {
        console.log("Form is NULL");
    }

        
});

function searchByAssetNo() {
    // Declare variables
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("assetNo");
    filter = input.value;
    table = document.getElementById("report-table");
    tr = table.getElementsByTagName("tr");
  
    // Loop through all table rows, and hide those who don't match the search query
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[0];
      if (td) {
        txtValue = td.textContent || td.innerText;
        if (txtValue.indexOf(filter) > -1) {
          tr[i].style.display = "";
        } else {
          tr[i].style.display = "none";
        }
      }
    }
  }