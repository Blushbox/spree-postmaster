Deface::Override.new(:virtual_path  => "spree/admin/orders/_shipment",
                     :name          => "add_print_label_to_order_edit",
                     :insert_before => "erb[loud]:contains(\"ship button icon-arrow-right\")",
                     :partial       => "spree/admin/orders/label")
