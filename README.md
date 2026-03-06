Some examples of work completed at BWS:

- Work performed primarily using Python, SQL Server 2008, and MS Access.

- Notable libraries and modules used; streamlit, pandas, numpy, plotly, altair, matplotlib, streamlit_js_eval, streamlit_extras, streamlit.components, geopy, cv2, pytesseract, pdfplumber, pyPDF2, asyncio, subprocess, pyodbc, moviepy, re, sqlparse, difflib, json, csv, PIL, wkhtmltopdf, pdfkit, pydeck, secrets, hashlib, tkinter, customtkinter, pyautogui, plyer, locale, shutil

- Focuses mainly on Dashboard generation, interactive charting, UI and UX development, automation, data and resource consolidation and other general process improvement ventures.

- The goal was to increase data visibility, reduce need and frequency of reconciliation, and produce robust histories recording how data was changed including all relevant details.

- Below are screenshots primarily from MS Access and Streamlit environments.

![](images/media/image1.png)

Output of a program that walks file trees and gathers documents based on pattern match for exporting. Reports any missed files such that appropriate personnel can be contacted to produce these files.

![](images/media/image2.png)

MS Access parameter form for custom printing of the production schedule. Offers tailored views to prune unnecessary info for users that do not wish to see certain dates or lines. Presets streamline data input to select information directed related to the user, such as printer location and lines.

![](images/media/image3.png)

View of the main Access database landing menu. The bottom right indicates a version control warning.

![](images/media/image4.png)

![](images/media/image5.png)

Custom heat map applied to the Main menu of a large Access database. Used to track program usage, and data pipelines, allowing senior management review how data is access, and where and who.

![](images/media/image6.png)

Input and Edit form for IT issues from an internal department view. Allows internal IT communicate and track issues. Uses SQL triggers to automate email notifications.

![](images/media/image7.png)

Streamlit interface to query database values using custom search criteria. Used internally to automaticity generate the query's code for IT to edit existing forms highlighting answers to common queries.

![](images/media/image8.png)

Testing area menu in Access offering users the ability to access project demos, and sensitive work-in-progress components. Once a project was deemed solid enough here it was moved to another portion of the program.

![](images/media/image9.png)

This form allows a user to automatically export and import text file resources between accdb files. Access uses text files to save resources and make the portable to new databases. Where two developers were constantly checking-out and returning one master copy of the DB, this offered us the ability to work concurrently if we prefixed our work with a project identifier. Then we could move files quickly and safely.

![](images/media/image10.png)

Streamlit dashboard charting for inventory allocations by model.

![](images/media/image11.png)

Generic dashboard for sales margin analysis. View is initial, showcasing the breadth of data that can be quickly referenced, stored and rendered is large.

![](images/media/image12.png)

Simple bar chart showing side-by-side comparison of some high-level job totals.

![](images/media/image13.png)

Plotly express timeline showing weeks worth of employee usages of certain access programs. Values are shown as aggregates of whole days effectively showing how much each user uses each access function.

![](images/media/image14.png)

Experimental program demonstrating a Work Order's StockCode allocations as a graph. Colour highlighting indicates issue status. Graph is interactive allowing selection to view the StockCode nodes.

![](images/media/image15.png)

![](images/media/image16.png)

Plotly charts showcasing figures from production and financial workflows. Graphs are completely interactive offering filtering, zooming, and leverages the built-in functions of this modern plotting library (hover tips, exporting snapshots, etc...).

![](images/media/image17.png)

Margin performance for a selected list of Work Orders, plotting a trend-line to provide improved insight. Graphs used in finance and BoM departments to monitor and present sales trends for specified groupings or selections.

![](images/media/image18.png)

Experimental program in Streamlit to demonstrate word patterns via a word-cloud. Currently showing model names for two separate companies.

![](images/media/image19.png)

IT request form recreated in Streamlit, offers an improvement to the Access version where a user can submit supporting docs via a file uploader widget. Files were copied to the request folder generated when a request is created. Build-time and maintenance is also a significant improvement to VBA solutions.

!](images/media/image20.png)![](images/media/image21.png)

Streamlit front-end for SQL server solutions. Program quickly writes boilerplate SQL to query against selected Databases for given values. Offers a variety of options to improve generated code results such as aliasing, normalized column names and syntax, table joins, and options for query style. Used by IT department to dynamically generate boilerplate to improve development times. Also maintained code integrity between developer's work.

![](images/media/image22.png)

Continuation of SQL generation program. Allows user to create a generic table with normalized column names and types. Generates four scripts to create the specified table with an accompanying history table, and two triggers to maintain history and LastModified DateActive / DateInActive columns.

![](images/media/image23.png)

![](images/media/image24.png)

Using geopy and Streamlit map widget, I can leverage MapBox, or google maps, to plot the address of each of the customers serviced by our company. Map provides some unique insight to potential market openings based on geography. Offered the ability to filter and hone into specific sales-person, dealer, or model data based on given criteria. Can graph sales points in 2D and 3D, adding a dimension for frequency or other sales values.

![](images/media/image25.png)

Created a Streamlit front-end to access common code resources used by the IT departments. Included examples of work, links to videos, and resources compiled to help remind the members how some specific pieces of code worked within the codebase. Showed examples for Python, VBA, and SQL solutions to a variety of tasks or functions required in every-day company operations. Extendable and scalable for new snippets provided by developers. Used an internal tag system to relate or connect resources.

![](images/media/image26.png)

Streamlit dashboard interface to compare a selected quote against recent performance, specifically production speed, checkpoint to checkpoint.

![](images/media/image27.png)

Streamlit program to view PDF Work Orders in a meeting setting. Program silently prompts Access to generate Work Order reports for a select list of quotes. It then attempts to annotate each option on the workorder via OCR techniques, highlighting each option in a clickable box with a red border. During the sales meeting a user would navigate each PDF and read the options for the specified order. Other departments would provide some feedback on potential issues with combined options on a model. The user would click the annotation, record the notes, and continue with the meeting. Quotes were then approved to move to the next level of production. This program replaced the tedious manual process of generating each report in series, recording, and tracking notes by hand, and maintaining a history.
