export default interface BookingModel {
    readonly id: number
    readonly name: string
    readonly checkinDate: number
    readonly checkoutDate: number
    readonly lastDateToCancel: number
    readonly startRoomPrice: number
    readonly priceNotifier: number
    readonly lastPrice: number | null
    readonly lastUpdateDate: number

}