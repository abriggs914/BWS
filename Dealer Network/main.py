import folium
import webbrowser

########################################################################################################################


class Map(folium.Map):

    def __init__(self, center, zoom_start, **kwargs):
        super().__init__(**kwargs)
        self.center = center
        self.zoom_start = zoom_start

    def showMap(self):
        # Create the map
        # my_map = folium.Map(location=self.center, zoom_start=self.zoom_start)
        self.location = self.center
        self.zoom_start = self.zoom_start
        # Display the map
        self.save("map.html")
        webbrowser.open("map.html")


def gen_pop_up_data(d):
    # dat = "Company:\n\t" + d['COMPANY NAME']
    # dat += "\nAddr:\n\t" + ", ".join([d["ADDRESS"], d["CITY"], d["PROVINCE"], d["POSTAL CODE"]])
    dat = '''<pre>Company:<br><br>    {cn}<br><br>Address:<br><br>    {ca}, {cc}, {cp}, {cpc}</pre>'''.format(
        cn=d["COMPANY NAME"], ca=d["ADDRESS"], cc=d["CITY"], cp=d["PROVINCE"], cpc=d["POSTAL CODE"])
    iframe = folium.IFrame(dat)
    popup = folium.Popup(iframe,
                         min_width=450,
                         max_width=450)
    return popup


data = {}

with open("out.csv", "r") as f:
    # f_dicts = csv.DictReader(f, delimiter=";;")
    f_lines = f.readlines()
    header = ""
    for i, f_line in enumerate(f_lines):
        f_spl = list(map(lambda s: str(s).strip(), f_line.split(";;")))
        if i > 0:
            if "NULL" not in f_line:
                f_dict = dict(zip(header, f_spl))
                data[i] = f_dict
                # for k, v in f_dict.items():
                #     print("k:", k, "v:", v)
                # data[i] = {str(k).strip(): str(v).strip() for k, v in f_dict.items()}
        else:
            header = f_spl

# Define coordinates of where we want to center our map
coords = [46.427230736465326, -67.70498453648138]  # BWS Centreville
mp = Map(center=coords, zoom_start=1)

# add marker one by one on the map
for i in range(1, len(data)):
    print("data[i]:", data[i])
    folium.Marker(
        location=[data[i]['LAT'], data[i]['LON']],
        popup=gen_pop_up_data(data[i]),
    ).add_to(mp)
mp.showMap()

# response = requests.get(
#     'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA')
#
# resp_json_payload = response.json()
#
# print(resp_json_payload)
# print(resp_json_payload['results'])
