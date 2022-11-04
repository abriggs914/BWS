from utility import *
import pandas as pd


excel_name = "./all units.xlsx"


def group_discounts(dealer=None, model=None, slot_or_market=None):
    if dealer is not None and dealer not in list_of_dealers:
        raise Exception(f"Dealer '{dealer}' not valid.")
    if model is not None and model not in list_of_models:
        raise Exception(f"Model '{model}' not valid.")
    if slot_or_market is not None and slot_or_market not in ("slot", "market"):
        raise Exception(f"Param slot_or_market '{slot_or_market}' not valid, must be one of 'slot' or 'market'.")

    if dealer is None:
        dealer = list_of_dealers
    else:
        dealer = [dealer]

    if model is None:
        model = list_of_models
    else:
        model = [model]

    if slot_or_market is None:
        slot_or_market = "slot"

    results = {}

    for d in dealer:
        for m in model:
            if d not in results:
                results[d] = {}
            results[d][m] = discounts_by_dealer[d][m][slot_or_market]

    return results


if __name__ == '__main__':

    df = pd.read_excel(excel_name)
    df = df.fillna(0)

    print(f"df\n{df}")

    list_of_dealers = set()
    list_of_models = set()

    discounts_by_dealer = dict()
    discounts_by_model = dict()

    curr_dealer = None
    curr_model = None

    for i, row in df.iterrows():
        print(f"{i=}")
        for j, k_v in enumerate(row.items()):
            print(f"{i=}, {j=}, {k_v=}")
            print(f"\t{curr_dealer=}, {curr_model=}")
            k, v = k_v
            curr_dealer = k
            if i == 0:
                if not k.startswith("Unnamed"):
                    if k in list_of_dealers:
                        raise Exception(f"Dealer '{k}', has already been processed")
                    list_of_dealers.add(k)
                    print(f"{k=}")
            else:
                pass

            if j == 1 and i > 1:
                if v in list_of_models:
                    raise Exception(f"Model '{v}', has already been processed")
                curr_model = v
                list_of_models.add(v)
                print(f"{v=}")

            # even cols are slots, odds are markets

            if not curr_dealer.startswith("Unnamed"):
                if curr_dealer is not None and curr_model is not None:
                    if curr_dealer not in discounts_by_dealer:
                        discounts_by_dealer[curr_dealer] = dict(zip(list_of_models, [{"slot": None, "market": None} for _ in list_of_models]))
                    if curr_model not in discounts_by_dealer[curr_dealer]:
                        discounts_by_dealer[curr_dealer][curr_model] = {"slot": None, "market": None}
                    key = "slot" if j % 2 == 0 else "market"
                    discounts_by_dealer[curr_dealer][curr_model][key] = v

            # if curr_dealer is not None and curr_model is not None:
            #     if curr_dealer not in discounts_by_dealer:
            #         discounts_by_dealer[curr_dealer] = dict(zip(list_of_models, [{"slot": None, "market": None} for _ in list_of_models]))
            #     key = "slot" if j % 2 == 0 else "market"
            #     discounts_by_dealer[curr_dealer][curr_model][key] = v

    print(f"{len(list_of_dealers)}, {list_of_dealers}")
    print(f"{len(list_of_models)}, {list_of_models}")
    print(f"{len(discounts_by_dealer)}, {discounts_by_dealer}")
    print(f"{len(discounts_by_dealer.keys())}, {discounts_by_dealer.keys()}")

    print(f"{discounts_by_dealer['Hale']['30NTT']['slot']=}")
    print(f"{discounts_by_dealer['Hale']['30NTT']['market']=}")

    print(f"{group_discounts('Hale', '30NTT')=}")
    print(f"{group_discounts(model='30NTT')=}")
    print(f"{group_discounts(dealer='Hale')=}")


