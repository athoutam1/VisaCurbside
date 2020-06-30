exports.Order = class Order {
  constructor(
    id,
    storeID,
    storeName,
    itemIDs,
    total,
    shopperID,
    isPending,
    isReadyForPickup,
    time
  ) {
    this.id = id;
    this.storeID = storeID;
    this.storeName = storeName;
    this.itemIDs = itemIDs;
    this.total = total;
    this.shopperID = shopperID;
    this.isPending = isPending;
    this.isReadyForPickup = isReadyForPickup;
    this.time = time;
  }
};
