import BookingModel from "./booking_model";

const bookings: readonly BookingModel[] = [
    {
        checkinDate: 1693008000000,
        checkoutDate: 1693180800000,
        lastDateToCancel: 1293939924567,
        id: 1,
        name: "Riu Plaza Fisherman's Wharf",
        startRoomPrice: 394.2,
        priceNotifier: 394.2,
        lastPrice: 1,
        lastUpdateDate: 1691866890162
    },
    {
        checkinDate: 1693180800000,
        checkoutDate: 1693353600000,
        lastDateToCancel: 1693769043449,
        id: 2,
        name: "The Bergson",
        startRoomPrice: 418,
        priceNotifier: 418,
        lastPrice: 1,
        lastUpdateDate: 1691866913024
    },
];

export default bookings;