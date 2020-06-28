exports.Order = class Order {
  constructor(id, storeID, itemIDs, shopperID, isPending, isReadyForPickup, time) {
    this.id = id;
    this.storeID = storeID;
    this.itemIDs = itemIDs;
    this.shopperID = shopperID;
    this.isPending = isPending;
    this.isReadyForPickup = isReadyForPickup;
    this.time = time;
  }
};
