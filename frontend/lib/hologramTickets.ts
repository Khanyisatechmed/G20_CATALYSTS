// Single source for Hologram Hub sessions and ticket prices (ZAR, per person).
// Used by the Hologram Hub page, the booking page and Ask Catalyst; change prices here only.
export const hologramSessions = ["09:30", "11:00", "13:30", "15:00", "17:30"];

export const hologramTicketPrices = [
  { category: "Adult", label: "Adult", price: 320 },
  { category: "Child", label: "Child (3–12)", price: 160 },
  { category: "Student", label: "Student", price: 220 },
  { category: "Family or Group", label: "Family or group", price: 250 }
] as const;

export type HologramTicketCategory = (typeof hologramTicketPrices)[number]["category"];

export const hologramPriceByCategory = Object.fromEntries(
  hologramTicketPrices.map((ticket) => [ticket.category, ticket.price])
) as Record<HologramTicketCategory, number>;
