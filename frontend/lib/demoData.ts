import { marketplaceProducts } from "@/lib/products";

export const demoRoles = [
  "Guest",
  "Registered Visitor",
  "Vendor",
  "Museum Staff",
  "Content Editor",
  "Cultural Reviewer",
  "Admin",
  "Super Admin"
];

export const demoVendors = [
  {
    slug: "nomsa-mthembu-weaving",
    businessName: "Nomsa Mthembu Weaving Studio",
    artisanName: "Nomsa Mthembu",
    province: "KwaZulu-Natal",
    town: "Nongoma",
    category: "Crafts",
    locationLabel: "Public market stall, approved for demo",
    coordinates: { x: "66%", y: "59%" },
    status: "Approved demo vendor",
    products: [marketplaceProducts[0]]
  },
  {
    slug: "mandla-clayworks",
    businessName: "Mandla Clayworks",
    artisanName: "Mandla Mthembu",
    province: "Limpopo",
    town: "Tzaneen",
    category: "Pottery",
    locationLabel: "Heritage centre partner stall",
    coordinates: { x: "58%", y: "28%" },
    status: "Pending verification demo",
    products: [marketplaceProducts[1]]
  },
  {
    slug: "gauteng-heritage-market",
    businessName: "Gauteng Heritage Market Collective",
    artisanName: "Collective vendor profile",
    province: "Gauteng",
    town: "Johannesburg",
    category: "Markets",
    locationLabel: "Public market area",
    coordinates: { x: "53%", y: "40%" },
    status: "Demo listing",
    products: []
  }
];

export const demoFood = [
  {
    name: "Limpopo Heritage Tasting Plate",
    province: "Limpopo",
    type: "Traditional food experience",
    note: "Demo food experience awaiting verified venue partner details."
  },
  {
    name: "Durban Market Food Walk",
    province: "KwaZulu-Natal",
    type: "Food market",
    note: "Demo route only. Ratings and opening hours require verified data."
  },
  {
    name: "Cape Heritage Kitchen Stories",
    province: "Western Cape",
    type: "Story-led cuisine",
    note: "Demo experience for showcasing itinerary integration."
  }
];

export const demoEvents = [
  {
    slug: "hologram-hub-preview-week",
    title: "Hologram Hub Preview Week",
    province: "Limpopo",
    category: "Museum event",
    dateLabel: "Demo date pending",
    status: "Unverified demo event"
  },
  {
    slug: "artisan-market-showcase",
    title: "National Artisan Market Showcase",
    province: "Gauteng",
    category: "Market",
    dateLabel: "Demo date pending",
    status: "Unverified demo event"
  },
  {
    slug: "heritage-schools-day",
    title: "Schools Heritage Learning Day",
    province: "Eastern Cape",
    category: "Educational",
    dateLabel: "Demo date pending",
    status: "Unverified demo event"
  }
];

export const demoBookings = [
  {
    reference: "CW-DEMO-RAIN-001",
    experience: "Balobedu Rain Queen Hologram Experience",
    date: "Demo date selected",
    status: "Reservation request",
    paymentStatus: "Not connected",
    checkInStatus: "QR ticket pending"
  }
];

export const demoOrders = [
  {
    reference: "CW-DEMO-ORDER-001",
    item: "Traditional Zulu Hat",
    status: "Draft order",
    fulfilment: "Vendor fulfilment not connected"
  }
];

export const adminMetrics = [
  { label: "Users", value: "8 roles", detail: "Demo RBAC model" },
  { label: "Vendors", value: "3 demo", detail: "Approval workflow scaffold" },
  { label: "Bookings", value: "1 request", detail: "No confirmed tickets" },
  { label: "Products", value: "2 AR items", detail: "3D model assets connected" }
];
