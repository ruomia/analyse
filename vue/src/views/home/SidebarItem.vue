<template>
    <div v-if="!item.hidden && item.children">
        <router-link
            v-if="!item.hidden && item.noDropdown && !item.children[0].children"
            :to="item.path + '/' + item.children[0].path"
        >
            <el-menu-item :index="item.path + '/' + item.children[0].path">
                <icon-svg v-if="item.icon" :icon-class="item.icon"></icon-svg>
                <span slot="title">{{ item.name }}</span>
            </el-menu-item>
        </router-link>

        <el-submenu
            :index="item.path"
            v-else-if="!item.noDropdown && !item.hidden"
        >
            <template slot="title">
                <icon-svg v-if="item.icon" :icon-class="item.icon"></icon-svg>
                <span v-if="item.name" slot="title">{{ item.name }}</span>
            </template>
            <template v-for="child in itemChildren">
                <sidebar-item
                    :key="child.path"
                    v-if="child.children && child.children.length > 0"
                    :item="child"
                >
                </sidebar-item>

                <router-link
                    :key="child.path"
                    v-else
                    :to="item.path + '/' + child.path"
                >
                    <el-menu-item :index="item.path + '/' + child.path">
                        <icon-svg
                            v-if="child.icon"
                            :icon-class="child.icon"
                        ></icon-svg>
                        <span slot="title">{{ child.name }}</span>
                    </el-menu-item>
                </router-link>
            </template>
        </el-submenu>
    </div>
</template>

<script>
export default {
    name: "SidebarItem",
    props: {
        item: {}
    },
    computed: {
        itemChildren: function() {
            return this.item.children.filter(v => !v.hidden);
        }
    },
    methods: {
        // 查找子节点是否有可显示的节点
        hasFilterChildrenHidden(children) {
            const showingChildren = children.filter(item => {
                return !item.hidden;
            });
            return showingChildren.length === 1;
        }
    }
};
</script>
