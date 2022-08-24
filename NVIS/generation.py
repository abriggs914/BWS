import pandas

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
        self._server_serial = None
        self._model_no = None
        self._wo = None
        self._length = None
        self._axles = None
        self._type_of_trailer = None
        self._type_of_body = None
        self._model_year = None
        self._units_to_date = None
        self._check_digit = None

    def calculate(self):
        self.details["orders"] = connect(f"SELECT * FROM [Orders] WHERE [Quote#] = {self.details['quote']}")
        self.details["snc_year"] = connect(f"SELECT * FROM [SNC Year] WHERE [Year] = {self.details['year']}")
        model_name = self.details['orders']['Model No'].tolist()[0]
        self.details["snc_type"] = connect(
            f"SELECT * FROM [SN Type] WHERE [Model No] = '{model_name}'")

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

            units_to_date = connect(sql_str)["X"].tolist()[0]
            units_to_date = (-1 if units_to_date is None else units_to_date) + 1
            if self.details["sequential"] is not None:
                units_to_date = int(self.details["sequential"]) + 1

            sequential = ("000000" + str(units_to_date))[-6:]

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

            self.model_no = model_name
            self.wo = self.details["orders"]["WO#"].tolist()[0]
            self.length = serial[6]
            self.axles = serial[7]
            self.type_of_trailer = serial[4]
            self.type_of_body = serial[5]
            self.model_year = serial[9]
            self.check_digit = serial[8]
            self.units_to_date = units_to_date

            # serial = list(map(str, serial))
            serial = [str(letter) if letter is not None else "_" for letter in serial]

            self.serial = ''.join(serial)
            ss = connect(f"EXEC [sp_SerialNumberCalc] @quote={self.details['quote']}, @year={self.details['year']}")
            if ss is not None and (isinstance(ss, pandas.DataFrame) and ss.size > 0):
                cols = ss.columns
                self.server_serial = ss[cols[0]].tolist()[0]

        else:
            print(f"Error, no records returned for quote: {self.details['quote']} for year: {self.details['year']}")

    def get_server_serial(self):
        return self._server_serial

    def set_server_serial(self, server_serial_in):
        self._server_serial = server_serial_in

    def del_server_serial(self):
        del self._server_serial

    def get_serial(self):
        if self._serial is None:
            self.calculate()
        return self._serial

    def set_serial(self, serial_in):
        self._serial = serial_in

    def del_serial(self):
        del self._serial

    def get_model_no(self):
        return self._model_no

    def set_model_no(self, model_no_in):
        self._model_no = model_no_in

    def del_model_no(self):
        del self._model_no

    def get_wo(self):
        return self._wo

    def set_wo(self, wo_in):
        self._wo = wo_in

    def del_wo(self):
        del self._wo

    def get_length(self):
        return self._length

    def set_length(self, length_in):
        self._length = length_in

    def del_length(self):
        del self._length

    def get_axles(self):
        return self._axles

    def set_axles(self, axles_in):
        self._axles = axles_in

    def del_axles(self):
        del self._axles

    def get_type_of_trailer(self):
        return self._type_of_trailer

    def set_type_of_trailer(self, type_of_trailer_in):
        self._type_of_trailer = type_of_trailer_in

    def del_type_of_trailer(self):
        del self._type_of_trailer

    def get_type_of_body(self):
        return self._type_of_body

    def set_type_of_body(self, type_of_body_in):
        self._type_of_body = type_of_body_in

    def del_type_of_body(self):
        del self._type_of_body

    def get_model_year(self):
        return self._model_year

    def set_model_year(self, model_year_in):
        self._model_year = model_year_in

    def del_model_year(self):
        del self._model_year

    def get_units_to_date(self):
        return self._units_to_date

    def set_units_to_date(self, units_to_date_in):
        self._units_to_date = units_to_date_in

    def del_units_to_date(self):
        del self._units_to_date

    def get_check_digit(self):
        return self._check_digit

    def set_check_digit(self, check_digit_in):
        self._check_digit = check_digit_in

    def del_check_digit(self):
        del self._check_digit

    def __repr__(self):
        return str(self.serial)

    server_serial = property(get_server_serial, set_server_serial, del_server_serial)
    serial = property(get_serial, set_serial, del_serial)
    model_no = property(get_model_no, set_model_no, del_model_no)
    wo = property(get_wo, set_wo, del_wo)
    length = property(get_length, set_length, del_length)
    axles = property(get_axles, set_axles, del_axles)
    type_of_trailer = property(get_type_of_trailer, set_type_of_trailer, del_type_of_trailer)
    type_of_body = property(get_type_of_body, set_type_of_body, del_type_of_body)
    model_year = property(get_model_year, set_model_year, del_model_year)
    units_to_date = property(get_units_to_date, set_units_to_date, del_units_to_date)
    check_digit = property(get_check_digit, set_check_digit, del_check_digit)
