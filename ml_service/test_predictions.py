from app.data.loader import load_dataset, load_single_fund
from app.models.predictor import Predictor
from pprint import pprint

df = load_dataset()
predictor = Predictor()

for isin in sorted(df["isin"].unique()):
    print("=" * 80)
    print(isin)

    history = load_single_fund(df, isin)

    pprint(predictor.predict_all(history))
    print()
