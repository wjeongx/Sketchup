puts __FILE__ if $JFDEBUG
# random_tin.rb Copyright (c) 2007 jim.foltz@gmail.com
module JF
    module RandomizeTIN
        def self.randomTin
            @h ||= "1"
            @p ||= "Keep"
            sel = Sketchup.active_model.selection[0]
            return unless sel
            return  unless sel.typename == "Group"
            res = UI.inputbox(["Height ", "Perimeter "],[@h.to_l, @p], ["","Keep|Randomize"], "Randomize TIN")
            return unless res
            @h       = res[0]
            @p       = res[1]
            faces    = sel.entities.find_all{|e| e.is_a?(Sketchup::Face)}
            mesh     = Geom::PolygonMesh.new
            edge_pts = []
            faces.each {|f|
                pts = []
                f.vertices.each{|v|
                    pts << v.position
                    if v.edges.length < 6
                        edge_pts << v.position
                    end
                }
                mesh.add_polygon pts
            }
            mesh.points.each {|pt|
                if @p=="Keep" and edge_pts.include?(pt)
                    next
                end
                i = mesh.point_index pt
                r = rand(@h*2.0+1.0)-@h
                z = pt.z
                z += r
                x = pt.x
                y = pt.y
                mesh.set_point(i, [x, y, z])
            }
            if Sketchup.version.to_f > 7.0
                Sketchup.active_model.start_operation("Randomize TIN", true)
            else
                Sketchup.start_operation("Randomize TIN")
            end
            g = Sketchup.active_model.active_entities.add_group
            g.entities.add_faces_from_mesh(mesh)
            g.transformation = sel.transformation
            Sketchup.active_model.commit_operation
        end
    end
end

unless file_loaded?("random_tin.rb")
    UI.menu("Plugins").add_item("Randomize TIN") { JF::RandomizeTIN.randomTin() }
    file_loaded("random_tin.rb")
end
