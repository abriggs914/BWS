# # import the library
# import folium
# # import time
#
# # Make an empty map
# m = folium.Map(location=[20,0], tiles="OpenStreetMap", zoom_start=2)
#
# # Show the map
# m
# # time.sleep(16)
#
# # Import the pandas library
import pandas as pd
import csv
#
# # Make a data frame with dots to show on the map
#
# data
#
# # add marker one by one on the map
# for i in range(0,len(data)):
#    folium.Marker(
#       location=[data.iloc[i]['lat'], data.iloc[i]['lon']],
#       popup=data.iloc[i]['name'],
#    ).add_to(m)
#
# # Show the map again
# m
#
# # Make an empty map
# n = folium.Map(location=[20,0], tiles="OpenStreetMap", zoom_start=2)
#
# # add marker one by one on the map
# for i in range(0,len(data)):
#    folium.Marker(
#       location=[data.iloc[i]['lat'], data.iloc[i]['lon']],
#       popup=data.iloc[i]['name'],
#       icon=folium.DivIcon(html=f"""<div style="font-family: courier new; color: blue">{data.iloc[i]['name']}</div>""")
#    ).add_to(n)
#
# # Show the map again
# n
# import folium
# from IPython.display import HTML, display
# # LDN_COORDINATES = (51.5074, 0.1278)
# # myMap = folium.Map(location=LDN_COORDINATES, zoom_start=12)
# # display(myMap)
#
# m = folium.Map([43,-100], zoom_start=4)
#
# html="""
#     <h1> This is a big popup</h1><br>
#     With a few lines of code...
#     <p>
#     <code>
#         from numpy import *<br>
#         exp(-2*pi)
#     </code>
#     </p>
#     """
# iframe = folium.element.IFrame(html=html, width=500, height=300)
# popup = folium.Popup(iframe, max_width=2650)
#
# folium.Marker([30,-100], popup=popup).add_to(m)
#
# display(m)

import folium
import webbrowser
import requests

dealerships = {}
data = pd.DataFrame({
    'lon': [-58, 2, 145, 30.32, -4.03, -73.57, 36.82, -38.5],
    'lat': [-34, 49, -38, 59.93, 5.33, 45.52, -1.29, -12.97],
    'name': ['Buenos Aires', 'Paris', 'melbourne', 'St Petersbourg', 'Abidjan', 'Montreal', 'Nairobi', 'Salvador'],
    'value': [10, 12, 40, 70, 23, 43, 100, 43]
}, dtype=str)


class Map(folium.Map):
    def __init__(self, center, zoom_start, **kwargs):
        super().__init__(**kwargs)
        self.center = center
        self.zoom_start = zoom_start

    def showMap(self):
        # Create the map
        # my_map = folium.Map(location=self.center, zoom_start=self.zoom_start)
        self.location=self.center
        self.zoom_start= self.zoom_start
        # Display the map
        self.save("map.html")
        webbrowser.open("map.html")


# Define coordinates of where we want to center our map
coords = [46.427230736465326, -67.70498453648138]
mp = Map(center=coords, zoom_start=13)

# add marker one by one on the map
for i in range(0, len(data)):
    folium.Marker(
        location=[data.iloc[i]['lat'], data.iloc[i]['lon']],
        popup=data.iloc[i]['name'],
    ).add_to(mp)
mp.showMap()

response = requests.get(
    'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA')

resp_json_payload = response.json()

print(resp_json_payload)
print(resp_json_payload['results'])
# print(resp_json_payload['results'][0]['geometry']['location'])

if False:
    with open("dealers_info.csv", "r") as f, open("out.csv", "w") as o, open("addresses.txt", "w") as a:
        f_dicts = csv.DictReader(f)
        o.write(";;".join(f_dicts.fieldnames))
        for f_dict in f_dicts:
            if "NULL" not in f_dict.values():
                o.write("\n" + ";;".join(list(map(lambda s: str(s).strip(), f_dict.values()))))
                a.write(", ".join(list(map(lambda s: str(s).strip(), f_dict.values()))) + "\n")
