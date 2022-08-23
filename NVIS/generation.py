from pyodbc_connection import connect
import tkinter

if __name__ == "__main__":
    ans = '2S9DATBOX5M115535'
    nvis = lambda cvma1, tt, bt, l, ac, gw, cd, my, mc, cvma2, pp: ("".join(
        list(map(lambda x: str(x)[:4], [cvma1[0:4], tt, bt, l, ac, gw, cd, my, mc, cvma2, pp])))).upper().strip()
    print("nvis:", nvis('2s9', 'dump', 'aluminum', '53', '3', '5432', '0', '2015', 'Mississauga', '11', '5535'))
    print("ans: ", ans)
    print("nvis == ans:",
          nvis('2s9', 'dump', 'aluminum', '53', '3', '5432', '0', '2015', 'Mississauga', '11', '5535') == ans)

    # Details
    details = {
        "quote": 25454,
        "year": 2022
    }

    details["orders"] = connect(f"SELECT * FROM [Orders] WHERE [Quote#] = {details['quote']}")
    details["snc_year"] = connect(f"SELECT * FROM [SNC Year] WHERE [Year] = {details['year']}")
    details["snc_type"] = connect(f"SELECT * FROM [SN Type] WHERE [Model No] = '{details['orders']['Model No'].tolist()[0]}'")
    # print(f"STOP!!! {details['orders']['Model No'].tolist()[0]}")

    print(f"details['orders']\n:{details['orders']}")
    print(f"details['snc_year']\n:{details['snc_year']}")

    if not details["orders"].empty:

        serial = [" " for _ in range(17)]

        digits = list(map(str, range(0, 10)))
        alphabet = list(map(chr, range(97, 122))) + ['_']
        alphabet_values = list(range(9)) + list(range(6)) + [7, 9] + list(range(2, 10)) + [-1000000]
        weights = [8, 7, 6, 5, 4, 3, 2, 10, None, 9, 8, 7, 6, 5, 4, 3, 2]

        def calc_check_digit():
            weight = 0
            for i, ser_wei in enumerate(zip(serial, weights)):
                ser, wei = ser_wei
                print(f"{ser=}, {wei=}")
                if wei is not None:
                    value = int(ser if str(ser) in digits else alphabet_values[alphabet.index(str(ser).lower())])
                    print(f"{ser=}, {wei=}, {value=}")
                    weight += value * wei
            val = str(weight % 11)
            val = val if val != '10' else 'X'
            return val

        sql_str = f"""
        SELECT
            MAX(CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER)) AS [X]
        from 
            Orders with (nolock)
        cross join
            [SNC Year] with (nolock)
        where
            [Year] = {details['year']}
            AND LEN([Serial Number]) = 17
            AND CHARINDEX(' ', [Serial Number]) = 0
            and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A%'
        ;
        """
        sequential = connect(sql_str)["X"].tolist()[0]
        sequential = (-1 if sequential is None else sequential) + 1

        print(f"PRE CALC SEQUENTIAL: <{sequential}>")
        sequential = ("000000" + str(sequential))[-6:]
        print(f"POST CALC SEQUENTIAL: <{sequential}>")

        print(f"Serial before: '{''.join(serial)}'")

        serial[0] = "2"  # Assigned by CVMA
        serial[1] = "X"  # Assigned by CVMA
        serial[2] = "B"  # Assigned by CVMA
        serial[3] = "B"  # BWS Trailer
        serial[4] = details["snc_type"]["Position5"].tolist()[0]  # Type of Trailer
        serial[5] = details["snc_type"]["Position6"].tolist()[0]  # Body Type
        serial[6] = details["snc_type"]["Position7"].tolist()[0]  # Length
        serial[7] = details["snc_type"]["Position8"].tolist()[0]  # Axles

        serial[9] = (details["snc_year"]["SN Yr"].tolist() if details["snc_year"]["SN Yr"].tolist() else ['_'])[0]  # Model Year
        serial[10] = "A"  # Plant of Manufacture

        serial[11:17] = sequential

        serial[8] = calc_check_digit()  # Check digit

        # serial = list(map(str, serial))
        serial = [str(letter) if letter is not None else "_" for letter in serial]

        print(f"serial: {serial}")

        print(f"Serial after : '{''.join(serial)}'")

    else:
        print(f"Error, no records returned for quote: {details['quote']} for year: {details['year']}")


class NVIS:

    def __init__(self, quote_number, production_year, sequential_start=None):
        # Details
        self.details = {
            "quote": quote_number,
            "year": production_year,
            "sequential": sequential_start
        }

        self.quote_number = quote_number
        self.production_year = production_year
        self.sequential_start = sequential_start
        self._serial = None

    def calculate(self):
        self.details["orders"] = connect(f"SELECT * FROM [Orders] WHERE [Quote#] = {self.details['quote']}")
        self.details["snc_year"] = connect(f"SELECT * FROM [SNC Year] WHERE [Year] = {self.details['year']}")
        self.details["snc_type"] = connect(
            f"SELECT * FROM [SN Type] WHERE [Model No] = '{self.details['orders']['Model No'].tolist()[0]}'")

        # print(f"details['orders']\n:{self.details['orders']}")
        # print(f"details['snc_year']\n:{self.details['snc_year']}")

        if not self.details["orders"].empty:

            serial = [" " for _ in range(17)]

            digits = list(map(str, range(0, 10)))
            alphabet = list(map(chr, range(97, 122))) + ['_']
            alphabet_values = list(range(9)) + list(range(6)) + [7, 9] + list(range(2, 10)) + [-1000000]
            weights = [8, 7, 6, 5, 4, 3, 2, 10, None, 9, 8, 7, 6, 5, 4, 3, 2]

            def calc_check_digit():
                weight = 0
                for i, ser_wei in enumerate(zip(serial, weights)):
                    ser, wei = ser_wei
                    if wei is not None:
                        print(f"{ser=}, {wei=}")
                        value = int(ser if str(ser) in digits else alphabet_values[alphabet.index(str(ser).lower())])
                        # print(f"{ser=}, {wei=}, {value=}")
                        weight += value * wei
                val = str(weight % 11)
                val = val if val != '10' else 'X'
                return val

            sql_str = f"""
                        SELECT
                            MAX(CAST([BWSdb].[dbo].[TrailingDigits](RIGHT([Serial Number], 6)) AS INTEGER)) AS [X]
                        from 
                            Orders with (nolock)
                        cross join
                            [SNC Year] with (nolock)
                        where
                            [Year] = {self.details['year']}
                            AND LEN([Serial Number]) = 17
                            AND CHARINDEX(' ', [Serial Number]) = 0
                            and RIGHT([Serial Number], 8) like '%' + [SN Yr] + 'A%'
                        ;
                        """

            if self.details["sequential"] is None:
                sequential = connect(sql_str)["X"].tolist()[0]
                sequential = (-1 if sequential is None else sequential) + 1
            else:
                sequential = int(self.details["sequential"]) + 1

            sequential = ("000000" + str(sequential))[-6:]

            serial[0] = "2"  # Assigned by CVMA
            serial[1] = "X"  # Assigned by CVMA
            serial[2] = "B"  # Assigned by CVMA
            serial[3] = "B"  # BWS Trailer
            serial[4] = self.details["snc_type"]["Position5"].tolist()[0]  # Type of Trailer
            serial[5] = self.details["snc_type"]["Position6"].tolist()[0]  # Body Type
            serial[6] = self.details["snc_type"]["Position7"].tolist()[0]  # Length
            serial[7] = self.details["snc_type"]["Position8"].tolist()[0]  # Axles

            serial[9] = (self.details["snc_year"]["SN Yr"].tolist() if self.details["snc_year"]["SN Yr"].tolist() else ['_'])[
                0]  # Model Year
            serial[10] = "A"  # Plant of Manufacture

            serial[11:17] = sequential

            serial[8] = calc_check_digit()  # Check digit

            # serial = list(map(str, serial))
            serial = [str(letter) if letter is not None else "_" for letter in serial]

            self.serial = ''.join(serial)

        else:
            print(f"Error, no records returned for quote: {self.details['quote']} for year: {self.details['year']}")

    def get_serial(self):
        if self._serial is None:
            self.calculate()
        return self._serial

    def set_serial(self, serial_in):
        self._serial = serial_in

    def del_serial(self):
        del self._serial

    def __repr__(self):
        return str(self.serial)

    serial = property(get_serial, set_serial, del_serial)
