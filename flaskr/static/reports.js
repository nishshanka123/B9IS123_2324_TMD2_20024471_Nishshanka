/**
 * JS file for displaying and handling report response.
 */
document.addEventListener('DOMContentLoaded', function() {
    //console.log('Hello World--------------------TEST');
    const form = document.getElementById('report-form');

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
            console.log(data);

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
            for (const key in data.JsonData[0]) {
                const th = document.createElement('th');
                th.textContent = key;
                headerRow.appendChild(th);
            }
            table.appendChild(headerRow);

            // Create table rows for each data record
            data.JsonData.forEach(record => {
                const row = document.createElement('tr');
                for (const key in record) {
                    const cell = document.createElement('td');
                    cell.textContent = record[key];
                    row.appendChild(cell);
                }
                table.appendChild(row);
            });
        })
        .catch(error => {
            console.error('Error Occurred:', error);
        });
    });
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