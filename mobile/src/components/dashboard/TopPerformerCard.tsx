import AppCard from "@/components/common/AppCard";
import AppText from "@/components/common/AppText";

interface Props {
  fund: any;
}

export default function TopPerformerCard({
  fund,
}: Props) {
  return (
    <AppCard>
      <AppText variant="heading">
        {fund.fund_name}
      </AppText>

      <AppText>
        YTD {(Number(fund.ytd_return) * 100).toFixed(2)}%
      </AppText>
    </AppCard>
  );
}