Deface::Override.new(:virtual_path  => "spree/admin/orders/_shipment",
                     :name          => "add_print_label_to_order_edit",
                     :insert_before  => "code[erb-loud]:contains(\"link_to 'ship', '#'\")",
                     :partial       => "spree/admin/orders/label")
