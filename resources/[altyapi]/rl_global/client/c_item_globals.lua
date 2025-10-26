function hasSpaceForItem( ... )
	return call( getResourceFromName( "erp_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "erp_items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "erp_items" ), "getItemName", itemID )
end
