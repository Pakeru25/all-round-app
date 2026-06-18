/**
 * Customer value tiers, derived from lifetime spend (total of their sales).
 * Single place to change the rule. Confirmed with the owner:
 *   Elite   = total spent >= GH₵1,200
 *   Edition = everyone below that (includes customers with no purchases yet)
 */

export type CustomerTier = "elite" | "edition";

/** Minimum lifetime spend (GH₵) to be an Elite customer. */
export const ELITE_MIN = 1200;

export const TIER_ORDER: CustomerTier[] = ["elite", "edition"];

export const TIER_LABELS: Record<CustomerTier, string> = {
  elite: "Elite",
  edition: "Edition",
};

export const TIER_BADGE: Record<CustomerTier, string> = {
  elite: "bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300",
  edition: "bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-300",
};

export function tierForSpend(totalSpent: number): CustomerTier {
  return totalSpent >= ELITE_MIN ? "elite" : "edition";
}
