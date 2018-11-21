/* Items.as
 * author: Aphelion
 */

#include "ItemsCommon.as";

void onInit( CRules@ this )
{
	Item[][] items;
	AddItems(this, items);
	
	this.set(items_property, items);
}
