;GIL-3
(
(
	:type                   :base-window
	:name                   xmount_main
	:owner                  nil
	:width                  527
	:height                 387
	:background-color       ""
	:foreground-color       ""
	:label                  "XMount"
	:label-type             :string
	:initial-state          :open
	:show-footer            nil
	:resizable              nil
	:icon-file              "glyphs/mount_icon.glyph"
	:icon-label             "XMount"
	:icon-mask-file         ""
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main)
		:when                   (Resize )
		:to                     (xmount_main)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (xmount_main_resize)
		)
		(
		:from                   (xmount_main)
		:when                   (Exit )
		:to                     (xmount_main)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (xmount_onterminate)
		)
	)
)
(
	:type                   :control-area
	:name                   lists_panel
	:owner                  xmount_main
	:help                   ""
	:x                      0
	:y                      0
	:width                  527
	:height                 189
	:background-color       ""
	:foreground-color       ""
	:initial-state          :visible
	:show-border            t
	:menu                   nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :scrolling-list
	:name                   mount_list
	:owner                  lists_panel
	:help                   "mount_list help"
	:x                      10
	:y                      10
	:width                  200
	:height                 170
	:value-x                10
	:value-y                10
	:rows                   7
	:foreground-color       ""
	:label                  ""
	:title                  "mounted:"
	:label-type             :string
	:layout-type            :horizontal
	:read-only              t
	:multiple-selections    nil
	:selection-required     nil
	:initial-state          :active
	:droppable              nil
	:default-drop-site      nil
	:menu                   nil
	:notify-handler         nil
	:event-handler          nil
	:initial-list-values    ()
	:initial-list-glyphs    ()
	:initial-selections     ()
	:user-data              ()
	:actions                ()
)
(
	:type                   :group
	:name                   mfs_group
	:x                      10
	:y                      10
	:group-type             nil
	:members                (mount_list )
	:rows                   0
	:row-alignment          :top-edges
	:columns                0
	:column-alignment       :left-edges
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          nil
	:anchor-point           :north-west
	:reference-point        :north-west
	:horizontal-offset      0
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :scrolling-list
	:name                   fstab_list
	:owner                  lists_panel
	:help                   ""
	:x                      300
	:y                      10
	:width                  200
	:height                 170
	:value-x                300
	:value-y                10
	:rows                   7
	:foreground-color       ""
	:label                  ""
	:title                  "available:"
	:label-type             :string
	:layout-type            :horizontal
	:read-only              t
	:multiple-selections    nil
	:selection-required     nil
	:initial-state          :active
	:droppable              nil
	:default-drop-site      nil
	:menu                   nil
	:notify-handler         nil
	:event-handler          nil
	:initial-list-values    ()
	:initial-list-glyphs    ()
	:initial-selections     ()
	:user-data              ()
	:actions                ()
)
(
	:type                   :group
	:name                   ufs_group
	:x                      300
	:y                      10
	:group-type             nil
	:members                (fstab_list )
	:rows                   0
	:row-alignment          :horizontal-centers
	:columns                0
	:column-alignment       :labels
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          nil
	:anchor-point           :north-east
	:reference-point        :north-west
	:horizontal-offset      10
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :button
	:name                   command_mount
	:owner                  lists_panel
	:help                   "command unmount help
"
	:x                      240
	:y                      30
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/unmount.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         cmd_unmount
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main command_mount)
		:when                   (Notify )
		:to                     (xmount_main command_mount)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (cmd_unmount)
		)
	)
)
(
	:type                   :button
	:name                   command_unmount
	:owner                  lists_panel
	:help                   "command mount help"
	:x                      240
	:y                      90
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/mount.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         cmd_mount
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main command_unmount)
		:when                   (Notify )
		:to                     (xmount_main command_unmount)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (cmd_mount)
		)
	)
)
(
	:type                   :text-pane
	:name                   status_pane
	:owner                  xmount_main
	:help                   ""
	:x                      0
	:y                      189
	:width                  527
	:height                 61
	:background-color       ""
	:foreground-color       ""
	:initial-state          :visible
	:show-border            t
	:read-only              t
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main status_pane)
		:when                   (Menu )
		:to                     (xmount_main status_pane)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (interpose_menu_popup)
		)
	)
)
(
	:type                   :control-area
	:name                   command_controls
	:owner                  xmount_main
	:help                   ""
	:x                      0
	:y                      250
	:width                  527
	:height                 60
	:background-color       ""
	:foreground-color       ""
	:initial-state          :visible
	:show-border            nil
	:menu                   nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :button
	:name                   command_help
	:owner                  command_controls
	:help                   ""
	:x                      10
	:y                      10
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/smile.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         cmd_help
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main command_help)
		:when                   (Notify )
		:to                     (xmount_main command_help)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (cmd_help)
		)
	)
)
(
	:type                   :button
	:name                   command_exit
	:owner                  command_controls
	:help                   ""
	:x                      60
	:y                      10
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/unsmile.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         cmd_exit
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main command_exit)
		:when                   (Notify )
		:to                     (xmount_main command_exit)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (cmd_exit)
		)
	)
)
(
	:type                   :control-area
	:name                   command_panel
	:owner                  xmount_main
	:help                   "command mount help"
	:x                      0
	:y                      310
	:width                  527
	:height                 77
	:background-color       ""
	:foreground-color       ""
	:initial-state          :visible
	:show-border            t
	:menu                   nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :text-field
	:name                   root_device
	:owner                  command_panel
	:help                   "root device help
"
	:x                      10
	:y                      10
	:width                  135
	:height                 15
	:value-x                65
	:value-y                10
	:value-length           10
	:stored-length          80
	:rows                   3
	:foreground-color       ""
	:text-type              :alphanumeric
	:label                  "device:"
	:label-type             :string
	:layout-type            :horizontal
	:value-underlined       t
	:initial-value          ""
	:initial-state          :active
	:read-only              nil
	:notify-handler         nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :text-field
	:name                   root_mnt
	:owner                  command_panel
	:help                   "root mount help
"
	:x                      27
	:y                      35
	:width                  102
	:height                 15
	:value-x                65
	:value-y                35
	:value-length           8
	:stored-length          80
	:rows                   3
	:foreground-color       ""
	:text-type              :alphanumeric
	:label                  "mnt:"
	:label-type             :string
	:layout-type            :horizontal
	:value-underlined       t
	:initial-value          ""
	:initial-state          :active
	:read-only              nil
	:notify-handler         nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :group
	:name                   root_left_group
	:x                      10
	:y                      10
	:group-type             :column
	:members                (root_device root_mnt )
	:rows                   0
	:row-alignment          :top-edges
	:columns                1
	:column-alignment       :labels
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          nil
	:anchor-point           :north-west
	:reference-point        :north-west
	:horizontal-offset      0
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :setting
	:name                   root_fsystem
	:owner                  command_panel
	:help                   "root fsystem help"
	:x                      175
	:y                      10
	:width                  212
	:height                 23
	:value-x                272
	:value-y                10
	:rows                   0
	:columns                1
	:layout-type            :horizontal
	:foreground-color       ""
	:setting-type           :stack
	:selection-required     t
	:label                  "file systems:"
	:label-type             :string
	:notify-handler         nil
	:event-handler          nil
	:choices                ("hpfs" "msdos" "sysv" "vfat" "ext2" "fat" "isofs" "minix" "ncpfs" "smbfs" "ufs" "umsdos" "proc" "xiafs" "iso9660" "swap" "nfs" "[unspecified]" )
	:choice-label-types     (:string :string :string :string :string :string :string :string :string :string :string :string :string :string :string :string :string :string )
	:choice-colors          ("" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" )
	:choice-defaults        (nil t nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil )
	:initial-selections     (nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil t )
	:initial-state          :active
	:user-data              ()
	:actions                ()
)
(
	:type                   :text-field
	:name                   root_options
	:owner                  command_panel
	:help                   "root options help"
	:x                      183
	:y                      43
	:width                  153
	:height                 15
	:value-x                272
	:value-y                43
	:value-length           8
	:stored-length          80
	:rows                   3
	:foreground-color       ""
	:text-type              :alphanumeric
	:label                  "additionnal:"
	:label-type             :string
	:layout-type            :horizontal
	:value-underlined       t
	:initial-value          ""
	:initial-state          :active
	:read-only              nil
	:notify-handler         nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :group
	:name                   root_right_group
	:x                      175
	:y                      10
	:group-type             :column
	:members                (root_fsystem root_options )
	:rows                   0
	:row-alignment          :top-edges
	:columns                1
	:column-alignment       :labels
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          root_left_group
	:anchor-point           :north-east
	:reference-point        :north-west
	:horizontal-offset      30
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :button
	:name                   root_command_unmount
	:owner                  command_panel
	:help                   "root command unmount help
"
	:x                      397
	:y                      10
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/unmount.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         root_cmd_unmount
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main root_command_unmount)
		:when                   (Notify )
		:to                     (xmount_main root_command_unmount)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (root_cmd_unmount)
		)
	)
)
(
	:type                   :button
	:name                   root_command_mount
	:owner                  command_panel
	:help                   "root command mount help"
	:x                      447
	:y                      10
	:width                  42
	:height                 42
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "glyphs/mount.glyph"
	:label-type             :glyph
	:initial-state          :active
	:menu                   nil
	:notify-handler         root_cmd_mount
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (xmount_main root_command_mount)
		:when                   (Notify )
		:to                     (xmount_main root_command_mount)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (root_cmd_mount)
		)
	)
)
(
	:type                   :group
	:name                   root_command_group
	:x                      397
	:y                      10
	:group-type             nil
	:members                (root_command_unmount root_command_mount )
	:rows                   0
	:row-alignment          :top-edges
	:columns                0
	:column-alignment       :labels
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          root_right_group
	:anchor-point           :north-east
	:reference-point        :north-west
	:horizontal-offset      10
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :popup-window
	:name                   about_box
	:owner                  xmount_main
	:width                  190
	:height                 138
	:background-color       ""
	:foreground-color       ""
	:label                  "About XMount"
	:label-type             :string
	:initial-state          :invisible
	:show-footer            nil
	:resizable              nil
	:pinned                 nil
	:done-handler           nil
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (about_box)
		:when                   (Resize )
		:to                     (about_box)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (about_box_resize)
		)
	)
)
(
	:type                   :control-area
	:name                   about_panel
	:owner                  about_box
	:help                   ""
	:x                      0
	:y                      0
	:width                  190
	:height                 138
	:background-color       ""
	:foreground-color       ""
	:initial-state          :visible
	:show-border            nil
	:menu                   nil
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :message
	:name                   about_text
	:owner                  about_panel
	:help                   ""
	:x                      52
	:y                      10
	:width                  75
	:height                 13
	:foreground-color       ""
	:label                  "XMount 1.0"
	:label-type             :string
	:label-bold             t
	:initial-state          :active
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :message
	:name                   about_text_1
	:owner                  about_panel
	:help                   ""
	:x                      10
	:y                      33
	:width                  158
	:height                 13
	:foreground-color       ""
	:label                  "(c) Daniel Doubrovkine"
	:label-type             :string
	:label-bold             t
	:initial-state          :active
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :message
	:name                   about_text_2
	:owner                  about_panel
	:help                   ""
	:x                      69
	:y                      56
	:width                  41
	:height                 13
	:foreground-color       ""
	:label                  "UniGe"
	:label-type             :string
	:label-bold             t
	:initial-state          :active
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :message
	:name                   about_text_3
	:owner                  about_panel
	:help                   ""
	:x                      73
	:y                      79
	:width                  32
	:height                 13
	:foreground-color       ""
	:label                  "1997"
	:label-type             :string
	:label-bold             t
	:initial-state          :active
	:event-handler          nil
	:user-data              ()
	:actions                ()
)
(
	:type                   :group
	:name                   text_group
	:x                      10
	:y                      10
	:group-type             :column
	:members                (about_text about_text_1 about_text_2 about_text_3 )
	:rows                   0
	:row-alignment          :top-edges
	:columns                1
	:column-alignment       :vertical-centers
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          nil
	:anchor-point           :north-west
	:reference-point        :north-west
	:horizontal-offset      0
	:vertical-offset        0
	:user-data              ()
	:actions                ()
)
(
	:type                   :button
	:name                   about_close
	:owner                  about_panel
	:help                   ""
	:x                      57
	:y                      102
	:width                  65
	:height                 19
	:constant-width         nil
	:button-type            :normal
	:foreground-color       ""
	:label                  "Thanks!"
	:label-type             :string
	:initial-state          :active
	:menu                   nil
	:notify-handler         about_box_close
	:event-handler          nil
	:user-data              ()
	:actions                (
		(
		:from                   (about_box about_close)
		:when                   (Notify )
		:to                     (about_box about_close)
		:function_type          CallFunction
		:arg_type               ()
		:action                 (about_box_close)
		)
	)
)
(
	:type                   :group
	:name                   ok_group
	:x                      57
	:y                      102
	:group-type             nil
	:members                (about_close )
	:rows                   0
	:row-alignment          :top-edges
	:columns                0
	:column-alignment       :vertical-centers
	:horizontal-spacing     10
	:vertical-spacing       10
	:anchor-object          text_group
	:anchor-point           :south
	:reference-point        :north
	:horizontal-offset      0
	:vertical-offset        10
	:user-data              ()
	:actions                ()
)
)
