function RetrieveReport()
{
    document.querySelector(`.box-report`).innerHTML += "<p>DATA</p>";
    console.log('Hello World');
    // fet the response
    /*fetch('/generateReports', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        console.log(data); // Do something with the JSON response
         // Get a reference to the div container
        const container = document.getElementById('box-report');

        // Create the table element
        const table = document.createElement('table');
        table.classList.add('table'); // Add Bootstrap table class if using Bootstrap
        
        // Create a header row
        const headerRow = document.createElement('tr');
        for (const key in data.JsonData[0]) {
            const th = document.createElement('th');
            th.textContent = key;
            headerRow.appendChild(th);
        }
        table.appendChild(headerRow);

    })
    .catch(error => {
    console.error('Error:', error);
    });
    */
}



function fetchAndRenderTable() {
    console.log('TEST: Hello World.................');
    fetch('/generateReports', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        console.log(data); // Log the JSON response for debugging
        
        // Use DOM tree to select the correct <div>
        const HTMLcontainer = document.getElementById('box-report');

        // Use js-dom library to populate the data
        // Start creating the table HTML element, change later for manage styling
        const table = document.createElement('table');
        table.classList.add('table');
        
        // Create a header row
        const ThRow = document.createElement('tr');
        for (const key in data.JsonData[0]) {
            const th = document.createElement('th');
            th.textContent = key;
            ThRow.appendChild(th);
        }
        table.appendChild(ThRow);

        // Create table rows and cells for each data record
        data.JsonData.forEach(record => {
            const Trow = document.createElement('tr');
            for (const key in record) {
                const cell = document.createElement('td');
                cell.textContent = record[key];
                Trow.appendChild(cell);
            }
            table.appendChild(Trow);
        });

        // Append the table to the HTMLcontainer
        HTMLcontainer.appendChild(table);
    })
    .catch(error => {
        console.error('Error:', error);
    });
}